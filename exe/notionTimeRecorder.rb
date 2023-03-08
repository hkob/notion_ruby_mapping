#! /usr/bin/env ruby

require "tk"
require "notion_ruby_mapping"
require "yaml"
require "time"
include Tk
include NotionRubyMapping

CONF_FILE_NAME = "#{ENV["HOME"]}/.notionTimeRecorder.yml"

class TaskConf
  KEY_TO_METHOD = {
    api_key: "NOTION_API_KEY",
    db_id: "TASK_DB_ID",
    tpn: "TITLE_PROPERTY_NAME",
    dpn: "DATE_PROPERTY_NAME",
    fpn: "FINISH_PROPERTY_NAME",
    fpt: "FINISH_PROPERTY_TYPE",
    ipv: "IN_PROGRESS_PROPERTY_VALUE",
    fpv: "FINISH_PROPERTY_VALUE",
    bln: "BLOCKING_PROPERTY_NAME",
    bbn: "BLOCKED_BY_PROPERTY_NAME",
    ppd: "PERCENT_PREVIOUS_DONE_FUNC_NAME",
  }

  # @param [Boolean] force_setup
  def initialize(yaml_name, force_setup = false)
    @yaml_name = yaml_name
    @config = {}
    setup(force_setup) if force_setup || !File.exist?(@yaml_name)
    load_conf
  end

  # @param [Boolean] force_setup
  def setup(force_setup)
    load_conf if force_setup
    @variables = {}
    @conf_frame = TkLabelFrame.new(nil, text: "Configuration").pack(padx: 10, pady: 10)
    KEY_TO_METHOD.each do |method, key|
      @variables[method] = TkVariable.new @config[key]&.to_s
      label_frame = TkLabelFrame.new(@conf_frame, text: key).pack(padx: 10, pady: 5)
      if method == :fpt
        TkRadioButton.new(label_frame, text: "status", variable: @variables[method], value: "status").pack
        TkRadioButton.new(label_frame, text: "checkbox", variable: @variables[method], value: "checkbox").pack
      else
        TkEntry.new(label_frame, textvariable: @variables[method]).pack
      end
    end
    cmd_frame = TkFrame.new(@conf_frame).pack
    TkButton.new(cmd_frame, text: "Quit", command: ->{ exit }).pack(side: :left)
    TkButton.new(cmd_frame, text: "Save", command: ->{ save }).pack(side: :right)
    Tk.mainloop
  end

  def load_conf
    @config = YAML.load_file @yaml_name
    KEY_TO_METHOD.each do |method, key|
      self.class.define_method(method) { @config[key] }
    end
  end
  
  def save
    KEY_TO_METHOD.each do |method, key|
      @config[key] = @variables[method].value.chomp
    end
    @config["FINISH_PROPERTY_VALUE"] = true if @config["FINISH_PROPERTY_VALUE"] == "true"
    File.open(@yaml_name, "w") do |f|
      YAML.dump @config, f
    end
    load_conf
    @conf_frame.destroy
    @task_cache = TaskCache.new self
  end
end

class Task
  # @param [NotionRubyMapping::Page] page
  # @param [TaskCache] tc
  def initialize(page, tc)
    @page = page
    @tc = tc
    @conf = tc.conf
    @date_property = @page.properties[@conf.dpn]
    @finish_property = @page.properties[@conf.fpn]
    @finish = (@conf.fpt == "status" ? @finish_property.status_name : @finish_property.checkbox) == @conf.fpv
    @start_date = @date_property.start_date_obj
    @end_date = @date_property.end_date_obj
  end

  def save
    @page.save
    @start_date = @date_property.start_date_obj
    @end_date = @date_property.end_date_obj
    @finish = (@conf.fpt == "status" ? @finish_property.status_name : @finish_property.checkbox) == @conf.fpv
  end

  def start_time_str
    @start_date.nil? || @start_date.is_a?(Date) ? "-" : @start_date.strftime("%H:%M")
  end

  def end_time_str
    @end_date.nil? || @end_date.is_a?(Date) ? "-" : @end_date.strftime("%H:%M")
  end

  def state
    @finish ? "disabled" : "normal"
  end

  def time_recording(force_set_date = false)
    if @start_date.nil? || force_set_date
      @date_property.start_date = Date.today
      @date_property.end_date = nil
      save
      @tc.move_to_today self
    elsif @start_date.is_a?(Date)
      @date_property.start_date = Time.now
      @finish_property.send("#{@conf.fpt}=", @conf.ipv) unless @conf.ipv.empty?
      @date_property.end_date = nil
      save
      @tc.update_today_tasks
    else
      @date_property.start_date = @date_property.start_date_obj
      @date_property.end_date = Time.now
      @finish_property.send("#{@conf.fpt}=", @conf.fpv)
      save
      if blocking_count&.positive?
        @tc.reload_someday
        @tc.update_today_tasks
      else
        @tc.update_today_tasks
      end
    end
  end

  def blocking_count
    @conf.bln.empty? ? nil : @page.properties[@conf.bln].relation.count
  end

  def view_task(frame, index, today_task = true)
    TkButton.new(frame, text: @page.title, state: state, command: -> { time_recording }).grid(row: index, column: 0)
    if today_task
      TkLabel.new(frame, text: start_time_str).grid(row: index, column: 1)
      TkLabel.new(frame, text: end_time_str).grid(row: index, column: 2)
    elsif (bcnt = blocking_count)
      TkLabel.new(frame, text: "+#{bcnt}").grid(row: index, column: 1)
    end
  end
end

class TaskCache
  # @param [TaskConf] conf
  def initialize(conf)
    @conf = conf
    NotionRubyMapping.configure do |c|
      c.notion_token = @conf.api_key
    end

    @db = Database.find conf.db_id
    @db_date_property, @db_finish_property = @db.properties.values_at @conf.dpn, @conf.fpn
    @today_tasks = []
    @someday_tasks = []
    @unfinished_tasks = []
    @new_today_task_val = TkVariable.new
    create_view
  end
  attr_reader :conf

  def create_view
    @today_outer_frame = TkLabelFrame.new(nil, text: "Today's tasks").pack(padx: 10, pady: 5)
    @today_inner_frame = nil
    @someday_outer_frame = TkLabelFrame.new(nil, text: "Someday").pack(padx: 10, pady: 5)
    @someday_inner_frame = nil
    @new_frame = TkLabelFrame.new(nil, text: "New task").pack(padx: 10, pady: 5)
    entry = TkEntry.new(@new_frame, textvariable: @new_today_task_val).pack(side: :left)
    entry.focus
    entry.bind("Return", -> { add_someday_task })
    TkButton.new(@new_frame, text: "Add", command: -> { add_someday_task }).pack(side: :right)

    cmd_frame = TkFrame.new(nil).pack(pady: 5)
    TkButton.new(cmd_frame, text: "Reload", command: ->{ reload }).pack(side: :left)
    TkButton.new(cmd_frame, text: "Quit", command: ->{ exit }).pack(side: :right)
    reload
  end

  def reload
    NotionCache.instance.clear_object_hash
    load_today_tasks
    load_unfinished_tasks
    update_today_tasks
    load_someday_tasks
    update_someday_tasks
  end

  def reload_someday
    NotionCache.instance.clear_object_hash
    load_someday_tasks
    update_someday_tasks
  end

  def load_unfinished_tasks
    now = Time.now
    end_of_day = Time.local(now.year, now.month, now.mday, 23, 59, 59) - 86400
    query = @db_date_property.filter_before(end_of_day)
                             .and(@db_finish_property.filter_does_not_equal(@conf.fpv))
    @unfinished_tasks = @db.query_database(query).map { |tp| Task.new tp, self }
  end

  def load_today_tasks
    query = @db_date_property.filter_equals(Date.today)
                             .ascending(@db_date_property)
    @today_tasks = @db.query_database(query).map { |tp| Task.new tp, self }
  end

  def update_today_tasks
    @today_inner_frame&.destroy
    @today_inner_frame = TkFrame.new(@today_outer_frame).pack
    @today_tasks.sort! { |a, b| a.start_time_str <=> b.start_time_str }
    @today_tasks.each_with_index { |task, i| task.view_task @today_inner_frame, i }
    uc = @unfinished_tasks.count
    TkButton.new(@today_inner_frame, text: "Add unfinished #{uc} tasks", command: -> { add_unfinished_tasks })
            .grid(row: @today_tasks.count, column: 0) if uc.positive?
  end

  def load_someday_tasks
    query = @db_date_property.filter_is_empty
                             .and(@db_finish_property.filter_does_not_equal(@conf.fpv))
    unless @conf.ppd.empty?
      ppd_p = @db.properties[@conf.ppd]
      query_is_empty = ppd_p.filter_is_empty another_type: "number"
      query_equals_1 = ppd_p.filter_equals 1, another_type: "number"
      query.and(query_is_empty.or(query_equals_1))
    end
    @someday_tasks = @db.query_database(query).map { |tp| Task.new tp, self }
  end

  def update_someday_tasks
    @someday_inner_frame&.destroy
    @someday_inner_frame = TkFrame.new(@someday_outer_frame).pack
    @someday_tasks.each_with_index { |task, i| task.view_task @someday_inner_frame, i, false }
  end

  def add_someday_task
    task_name = @new_today_task_val.value
    if !@conf.bbn.empty? && task_name.include?("|")
      previous_id = nil
      task_name.split("|").each do |title|
        page = @db.create_child_page do |_, pp|
          pp[@conf.tpn] << title
          pp[@conf.bbn].relation = previous_id if previous_id
        end
        previous_id = page.id
      end
      @new_today_task_val.value = ""
      reload
    else
      tp = @db.create_child_page do |_, pp|
        pp[@conf.tpn] << task_name
      end
      @new_today_task_val.value = ""
      @someday_tasks << Task.new(tp, self)
      update_someday_tasks
    end
  end

  def add_unfinished_tasks
    @unfinished_tasks.each do |task|
      task.time_recording true
    end
    @unfinished_tasks = []
    update_today_tasks
  end

  def move_to_today(task)
    @someday_tasks.delete task
    @today_tasks << task
    update_today_tasks
    update_someday_tasks
  end
end

@task_conf = TaskConf.new CONF_FILE_NAME, ARGV.first == "-c"
@task_cache = TaskCache.new @task_conf
Tk.mainloop
