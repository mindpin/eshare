class Ability
  include CanCan::Ability

  def initialize(user)
    ## ADMIN : 系统管理员功能

    # ADMIN1 : 用户管理
      # ADMIN1-1 : 下载EXCEL用户导入示例文件，从EXCEL文件导入用户
      # ADMIN1-2 : 通过web增删改系统内用户
      # ADMIN1-3 : 通过web修改用户的角色
    if !user.blank? && user.is_admin?
      can :manage, User
    end

    # ADMIN2 : 网盘公共资源库分类管理
      # ADMIN2-1 : 下载公共资源库分类YAML示例文件，从YAML文件导入公共资源库分类
      # ADMIN2-2 : 通过web增删改公共资源分类
    if !user.blank? && user.is_admin?
      can :manage, Category
    end

    # ADMIN3 : 用户对应角色的动态字段配置
      # ADMIN3-1 : 学生(student)角色的动态字段配置
      # ADMIN3-2 : 老师(teacher)角色的动态字段配置
    if !user.blank? && user.is_admin?
      can :manage, AttrsConfig
    end

    # ADMIN4 : 系统数据初始化向导
      # ADMIN4-1 : 预置公共资源库分类初始化向导
      # ADMIN4-2 : 预置学生动态字段初始化向导
      # ADMIN4-3 : 预置公开通识类课程初始化向导
      # ADMIN4-4 : 个人网盘预置目录结构初始化向导
    if !user.blank? && user.is_admin?
      can :init, :import
    end

    ## COURSE : 课程

    # COURSE1 : 课程编辑
      # COURSE1-1 : 通过WEB增删课程，增删课程下章节，增删章节下课件/练习
      # COURSE1-2 : 通过WEB导出和导入课程包
      # COURSE1-3 : 给课程添加公共标签
    if !user.blank? && (user.is_admin? || user.is_manager? || user.is_teacher?)
      can :manage, Course
      can :manage, Chapter
      can :manage, CourseWare
    end

    # COURSE2 : 课程浏览和学习进度记录
    # COURSE2-1 : 课程浏览
    if !user.blank?
      can :show, Course
      can :sign, Course
    end
    # COURSE2-2 : 课件/小节浏览和学习进度记录 [STUDENT 学生]
    # COURSE2-3 : 练习浏览和练习提交 [STUDENT 学生]
    if !user.blank? && user.is_student?
      can :show, CourseWare
      can :show, Chapter
      can :record, CourseWareReading
    end
    # COURSE2-4 : 课程首页签到 [ALL 全部]
    if !user.blank?
      can :sign, Course
    end

    # COURSE3 : 课程相关统计和信息图 [ALL 全部]
      # COURSE3-1 : 课程学习进度统计和学习进度排名
      # COURSE3-1 : 课程学习时间线展示
    if !user.blank?
      can :chart, Course
      can :feed_timeline, Course
    end

    # COURSE5 : 选课与选课确认
    # COURSE5-1 : 创建选课记录 [STUDENT 学生]
    # COURSE5-2 : 浏览选课记录和确认选课记录 [MANAGER 教学管理员]
    #TODO

    ## QUESTION : 问答

    # QUESTION1 : 提问与回答 [STUDENT 学生]
      # QUESTION1-1 : 在公共问答区提出问题
      # QUESTION1-2 : 在课程章节下提出问题
      # QUESTION1-3 : 在问题中添加/修改回答 (修改必须是本人)
      # QUESTION1-4 : 对回答进行投票
      # QUESTION1-5 : 提问者指定最佳答案 (问题创建者)
      # QUESTION1-6 : 指名问答
    if !user.blank? && user.is_student?
      can :public_create, Question
      can :course_create, Question
      can :create, Answer
      can :update, Answer do |answer|
        answer.creator == user
      end
      can :vote, Question
      can :set_best_answer, Question
    end
 
    # QUESTION2 : 问答订阅(follow) [ALL 全部]
      # QUESTION2-1 : 订阅一个问答
      # QUESTION2-2 : 通知订阅者问答的状态变化
    if !user.blank?
      can :follow, Question
    end

    ## FOLLOW : 用户关注 [ALL 全部]

    # FOLLOW1 : 用户间FOLLOW
      # FOLLOW1-1 : FOLOW/UNFOLLOW一个用户
      # FOLLOW1-2 : 查看我FOLLOW的用户列表
      # FOLLOW1-3 : 查看FOLLOW我的用户列表
      # FOLLOW2 : 显示用户状态时间线
    if !user.blank?
      can :follow, User
    end

    # COMMENT : 评论 [ALL 全部]
      # COMMENT1 : 基础评论组件
      # COMMENT2 : 评论管理
      # COMMENT2-1 : 查看当前用户发布的评论
      # COMMENT2-2 : 查看指定资源下的评论
      # COMMENT2-3 : 查看所有回复给当前用户的评论
    if !user.blank?
      can :follow, SimpleComment::Comment
    end

    ## TEST : 题库/组卷
    # TEST1 : 题库编辑/发布 [MANAGER 教学管理员]
      # TEST1-1 : 创建题库/增加多类型试题
      # TEST1-2 : 设定组卷参数
    if !user.blank? && user.is_manager?
      can :manage, TestQuestion
    end
    # TEST2 : 做题 [STUDENT 学生]
      # TEST2-1 : 根据组卷参数生成试卷
      # TEST2-2 : 提交试卷和自动打分
    if !user.blank? && user.is_student?
      can :use, TestQuestion
    end
    # TEST3 : 成绩统计和报告 [MANAGER 教学管理员]
    if !user.blank? && user.is_manager?
      can :chart, TestQuestion
    end

    ## NOTICE : 通知
    # NOTICE1 : 通知的编辑/发布 [MANAGER 教学管理员]
    if !user.blank? && user.is_manager?
      can :manage_notice, User
    end
    # NOTICE2 : 通知的查看 [ALL 全部]
      # NOTICE2-1 : 查看管理员发布的通知列表
      # NOTICE2-2 : 查看由系统自动发送的通知列表
    if !user.blank?
      can :show_notice, User
    end

    ## DASHBOARD : 工作台
    # DASHBOARD1 : 个人工作台 [ALL 全部]
    if !user.blank?
      can :dashboard, User
    end
    # DASHBOARD2 : 各个功能的DASHBOARD [根据功能来定]
    #TODO

    # HOMEPAGE : 个人主页 [ALL 全部]
      # HOMEPAGE1 : 查看自己的个人主页
      # HOMEPAGE2 : 查看他人的个人主页
    if !user.blank?
      can :homepage, User
    end

    # MESSAGE : 站内信 [ALL 全部]
      # MESSAGE1 : 站内信基础交互
      # MESSAGE2 : 即时聊天风格的站内信交互
    if !user.blank?
      can :crud, ShortMessage
    end

    ## TAG : 标签 [ALL 全部]
    # TAG1 : 通过标签查找对应资源
      # TAG1-1 : 通过标签查找文件资源
      # TAG1-2 : 通过标签查找课程资源
    if !user.blank?
      can :tag, MediaResource
      can :tag, Course
    end

    ## DISK : 网盘 [ALL 全部]
    # DISK1 : 个人网盘管理
      # DISK1-1 : 目录结构浏览
      # DISK1-2 : 文件资源展示(show)
      # DISK1-3 : 文件/文件夹资源增删，位置移动
      # DISK1-4 : 文件资源TAG维护
    # DISK2 : 网盘内容共享
      # DISK2-1 : 共享/取消共享文件/文件夹给指定用户
      # DISK2-2 : 生成文件共享链接
    # DISK3 : 公共资源库
      # DISK3-1 : 公共资源库目录结构浏览
      # DISK3-2 : 添加/取消添加个人文件/文件夹到公共资源库
    if !user.blank?
      can :crud, MediaResource
    end
  end

end