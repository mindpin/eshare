class InstallController < ApplicationController
  layout 'install'
  before_filter :check_step
  def check_step
    return redirect_to "/" if _is_install_success?
    count = (params[:step]||"step0").gsub('step','').to_i
    success_step_count = _get_install_step_count.to_i
    if success_step_count != count
      redirect_to "/install/step#{success_step_count}"
    end
  end

  def index
    _set_install_step_count(1) if _get_install_step_count == 0

    redirect_to "/install/step1"
  end

  def step
    send(params[:step])
  end

  def step_submit
    send("#{params[:step]}_submit")
  end

  def step1
    render "install/step1"
  end

  def step1_submit
    if params[:password].blank? || params[:email].blank? || params[:password] != params[:password_confirm]
      return redirect_to '/install/step1'
    end

    User.create(
      :login => 'admin', 
      :name => '管理员', 
      :email => params[:email], 
      :password => params[:password], 
      :role => :admin)
    _set_install_step_count(2)
    redirect_to "/install/step2"
  end

  def step2
    render "install/step2"
  end

  def step2_submit
    TermOutputReporter.new("bundle exec rails r script/simple/categories.rb RAILS_ENV=#{Rails.env}").run
    _set_install_step_count(3)
    render :text => "success"
  end

  def step3
    render "install/step3"
  end

  def step3_submit
    TermOutputReporter.new("bundle exec rails r script/simple/student_attrs_configs.rb RAILS_ENV=#{Rails.env}").run
    _set_install_step_count(4)
    render :text => "success"
  end

  def step4
    render "install/step4"
  end

  def step4_submit
    if params[:skip] == 'true'
      _install_success!
      return redirect_to '/'
    end
    TermOutputReporter.new("bundle exec rails r script/simple/import_courses.rb RAILS_ENV=#{Rails.env}").run
    _install_success!
    render :text => "success"
  end

  private
    def _get_install_step_count
      path = Rails.root.join('public/install_step')
      return 0 if !File.exists?(path)
      step_count = File.open(path,'r').read
      step_count.blank? ? 0 : step_count
    end

    def _set_install_step_count(count)
      File.open(Rails.root.join('public/install_step'),'w') do |f|
        f << count
      end
    end

    def _install_success!
      File.open(Rails.root.join('public/install_success'),'w') do |f|
        f << 'success'
      end
    end

    def _is_install_success?
      File.exists?(Rails.root.join('public/install_success'))
    end
end