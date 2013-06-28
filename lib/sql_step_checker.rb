class SqlStepChecker
  def initialize(sql_step, input, user)
    @sql_step = sql_step
    @input = input
    @user = user
  end

  def db
    _init_sandbox_db
  end

  def run
    begin
      rows = db.execute(@input)
    rescue Exception => e
      exception = e.message
    end

    {:result => rows, :exception => exception, :input => @input}
  end

  def check
    hash = @sql_step.run(@input, @user)
    result = hash[:result]
    exception = hash[:exception]
    input = hash[:input]
    if @sql_step.rule.blank?
      return true
    else
      instance_eval(@sql_step.rule)
    end
  end

  private
    def _init_sandbox_db
      path = File.join(R::UPLOAD_BASE_PATH,'sqlite_dbs', "user_#{@user.id}")
      FileUtils.mkdir_p(path) unless File.exists?(path)

      db_file_path = File.join(path, "#{@user.id}.db")

      SQLite3::Database.new db_file_path
    end
end