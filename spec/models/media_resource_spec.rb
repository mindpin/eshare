require 'spec_helper'

describe MediaResource do

  describe '私有方法' do
    it '能够切分传入的路径' do
      MediaResource.split_path('/foo/bar/123').should == ['foo', 'bar', '123']
      MediaResource.split_path('/foo/bar').should == ['foo', 'bar']
      MediaResource.split_path('/foo').should == ['foo']
      MediaResource.split_path('/中国国宝大熊猫').should == ['中国国宝大熊猫']
    end

    it '对于传入的无效路径会抛出异常' do
      expect {
        MediaResource.split_path(nil)
      }.to raise_error(MediaResource::InvalidPathError)

      expect {
        MediaResource.split_path('')
      }.to raise_error(MediaResource::InvalidPathError)

      expect {
        MediaResource.split_path('/')
      }.to raise_error(MediaResource::InvalidPathError)

      expect {
        MediaResource.split_path('foo/bar')
      }.to raise_error(MediaResource::InvalidPathError)

      expect {
        MediaResource.split_path('//foo')
      }.to raise_error(MediaResource::InvalidPathError)

      expect {
        MediaResource.split_path('/ha///ha')
      }.to raise_error(MediaResource::InvalidPathError)

      expect {
        MediaResource.split_path('/fo\o')
      }.to raise_error(MediaResource::InvalidPathError)
    end
  end

  describe '资源操作' do

    before do
      @ben7th = User.create!(
        :login => 'ben7th',
        :name  => 'ben7th',
        :email => 'ben7th@sina.com',
        :password => '123456',
        :role     => :teacher
      )

      @lifei = User.create!(
        :login => 'lifei',
        :name  => 'lifei',
        :email => 'fushang318@gmail.com',
        :password => '123456',
        :role     => :teacher
      )

      MediaResource.create(
        :name    => '北极熊',
        :is_dir  => true,
        :creator => @ben7th,
        :media_resources => [
          MediaResource.new(
            :name    => '企鹅',
            :is_dir  => true,
            :creator => @ben7th,
            :media_resources => [
              MediaResource.new(:name => '兔斯基.jpg.gif', :is_dir => false, :creator => @ben7th),
              MediaResource.new(:name => '狗头.jpg', :is_dir => false, :creator => @ben7th)
            ]
          )
        ]
      )

      tmpfile = Tempfile.new('panda')
      tmpfile.write('hello world')

      MediaResource.create(
        :name   => '大熊猫',
        :is_dir => true,
        :creator => @ben7th,
        :media_resources => [
          MediaResource.new(
            :name => '三只熊猫.jpg', 
            :is_dir => false,
            :creator => @ben7th,
            :file_entity => FileEntity.new(:attach => tmpfile)
          ),
          MediaResource.new(
            :name => '倒挂.jpg', 
            :is_dir => false,
            :creator => @ben7th,
            :file_entity => FileEntity.new(:attach => tmpfile)
          ),
          MediaResource.new(:name => '这是寂寞.jpg', :is_dir => false, :creator => @ben7th)
        ]
      )

      MediaResource.create(:name => '宋亮.png', :is_dir => false, :creator => @ben7th)
      MediaResource.create(:name => '太极图.jpg', :is_dir => false, :creator => @ben7th)
      MediaResource.create(:name => '很多猫.jpg', :is_dir => false, :creator => @ben7th)
      MediaResource.create(:name => '月球.jpg', :is_dir => false, :creator => @ben7th)

      MediaResource.create(:name => '必胜客.txt', :is_dir => false, :is_removed => true, :creator => @ben7th)
      MediaResource.create(:name => '蓝蓝路.txt', :is_dir => false, :is_removed => true, :creator => @ben7th)
      MediaResource.create(:name => '可乐', :is_dir => true, :is_removed => true, :creator => @ben7th)
    end

    describe '获取资源' do
      it '传入的路径没有资源时，返回空' do
        MediaResource.get(@ben7th, '/foo/bar/123').should == nil
        MediaResource.get(@ben7th, '/foo/bar').should == nil
        MediaResource.get(@ben7th, '/foo').should == nil
        MediaResource.get(@ben7th, '/中国国宝大熊猫').should == nil
        MediaResource.get(@ben7th, '/北极熊/HTC').should == nil
      end

      it '传入的路径有资源时，返回指定资源' do
        MediaResource.get(@ben7th, '/北极熊').is_dir.should == true
        MediaResource.get(@ben7th, '/北极熊/企鹅/兔斯基.jpg.gif').is_dir.should == false
        MediaResource.get(@ben7th, '/宋亮.png').is_dir.should == false
      end

      it '传入无效路径时，返回空' do
        MediaResource.get(@ben7th, '/').should == nil
        MediaResource.get(@ben7th, '/fo\o/bar').should == nil
        MediaResource.get(@ben7th, '/f//f').should == nil
      end

      it '传入的路径对应已经被删除的资源时，返回空' do
        MediaResource.get(@ben7th, '/必胜客.txt').should == nil
        MediaResource.get(@ben7th, '/可乐').should == nil

        MediaResource.get(@ben7th, '/北极熊/企鹅/兔斯基.jpg.gif').should_not == nil
        MediaResource.get(@ben7th, '/北极熊/企鹅/兔斯基.jpg.gif').remove
        MediaResource.get(@ben7th, '/北极熊/企鹅/兔斯基.jpg.gif').should == nil

        MediaResource.get(@ben7th, '/大熊猫').should_not == nil
        MediaResource.get(@ben7th, '/大熊猫/这是寂寞.jpg').should_not == nil
        MediaResource.get(@ben7th, '/大熊猫').remove
        MediaResource.get(@ben7th, '/大熊猫').should == nil
        MediaResource.get(@ben7th, '/大熊猫/这是寂寞.jpg').should == nil
      end
    end

    describe '创建资源' do
      describe '创建文件资源' do

        file = Tempfile.new('test')

        it '创建资源后应该可以拿到' do
          MediaResource.get(@ben7th, '/酸梅汤.html').should == nil
          MediaResource.get(@ben7th, '/红枣/绿豆.png').should == nil

          MediaResource.put(@ben7th, '/酸梅汤.html', file)
          MediaResource.get(@ben7th, '/酸梅汤.html').should_not == nil

          MediaResource.put(@ben7th, '/红枣/绿豆.png', file)
          MediaResource.get(@ben7th, '/红枣').is_dir.should == true
          MediaResource.get(@ben7th, '/红枣/绿豆.png').is_dir.should == false
        end

        it '传入无效路径后，创建资源抛出异常' do
          expect {
            MediaResource.put(@ben7th, nil, file)
          }.to raise_error(MediaResource::InvalidPathError)

          expect {
            MediaResource.put(@ben7th, 'haha', file)
          }.to raise_error(MediaResource::InvalidPathError)

          expect {
            MediaResource.put(@ben7th, '/', file)
          }.to raise_error(MediaResource::InvalidPathError)

          expect {
            MediaResource.put(@ben7th, '/fo\o', file)
          }.to raise_error(MediaResource::InvalidPathError)
        end

        it '先删除一个资源，再针对同样的路径创建资源，资源可以取到，且资源总数不变' do
          MediaResource.get(@ben7th, '/太极图.jpg').should_not == nil

          count = MediaResource.count
          removed_count = MediaResource.removed.count

          MediaResource.get(@ben7th, '/太极图.jpg').remove
          MediaResource.count.should == count - 1
          MediaResource.removed.count.should == removed_count + 1

          MediaResource.put(@ben7th, '/太极图.jpg', file)
          MediaResource.count.should == count
          MediaResource.removed.count.should == removed_count
        end

        it '可以以文件覆盖文件夹，覆盖时，文件夹下所有资源被删除' do
          MediaResource.get(@ben7th, '/大熊猫').is_dir?.should == true
          MediaResource.get(@ben7th, '/大熊猫/倒挂.jpg').is_file?.should == true
          MediaResource.get(@ben7th, '/大熊猫/这是寂寞.jpg').is_file?.should == true

          MediaResource.replace(@ben7th, '/大熊猫', file)
          MediaResource.get(@ben7th, '/大熊猫').is_file?.should == true
          MediaResource.get(@ben7th, '/大熊猫/倒挂.jpg').should == nil
          MediaResource.get(@ben7th, '/大熊猫/这是寂寞.jpg').should == nil
        end

        it '当创建深层文件资源时，父文件夹包含已被删除的文件夹资源，则创建后应是非删除状态' do
          MediaResource.get(@ben7th, '/可乐').should == nil
          MediaResource.removed.root_res.find_by_name('可乐').should_not == nil

          MediaResource.get(@ben7th, '/可乐/凉茶').should == nil

          MediaResource.put(@ben7th, '/可乐/凉茶/白开水.zip', file)

          MediaResource.get(@ben7th, '/可乐').is_dir?.should == true
          MediaResource.get(@ben7th, '/可乐/凉茶').is_dir?.should == true
          MediaResource.get(@ben7th, '/可乐/凉茶/白开水.zip').is_file?.should == true
        end

        it '当创建深层文件资源时，父文件夹是已存在的文件，则覆盖已存在的文件为文件夹' do
          MediaResource.get(@ben7th, '/月球.jpg').is_file? == true

          MediaResource.put(@ben7th, '/月球.jpg/花火/群星.ppt', file)

          MediaResource.get(@ben7th, '/月球.jpg').is_dir? == true
          MediaResource.get(@ben7th, '/月球.jpg').is_file? == false

          MediaResource.get(@ben7th, '/月球.jpg/花火').is_dir? == true
          MediaResource.get(@ben7th, '/月球.jpg/花火/群星.ppt').is_file? == true
        end

        it '当创建深层文件资源时，父文件夹是已删除的文件，则创建后应该是未删除的文件夹' do
          MediaResource.get(@ben7th, '/必胜客.txt').should == nil
          MediaResource.removed.root_res.find_by_name('必胜客.txt').is_file? == true

          count = MediaResource.count
          removed_count = MediaResource.removed.count

          MediaResource.put(@ben7th, '/必胜客.txt/星之所在.mp3', file)
          MediaResource.get(@ben7th, '/必胜客.txt').should_not == nil
          MediaResource.get(@ben7th, '/必胜客.txt').is_dir?.should == true
          MediaResource.get(@ben7th, '/必胜客.txt/星之所在.mp3').is_file?.should == true

          MediaResource.count.should == count + 2        
          MediaResource.removed.count.should == removed_count - 1
        end

        it '创建资源时文件参数不能传 nil 否则抛异常' do
          expect {
            MediaResource.put(@ben7th, '/fooo/barrr/hoho', nil)
          }.to raise_error(MediaResource::FileEmptyError)
        end
      end

      describe '创建文件夹资源' do
        it '当指定位置已经存在任何资源时，抛出异常' do
          MediaResource.get(@ben7th, '/太极图.jpg').should be_is_file
          MediaResource.get(@ben7th, '/大熊猫').should be_is_dir

          expect {
            MediaResource.create_folder(@ben7th, '/太极图.jpg')
          }.to raise_error(MediaResource::RepeatedlyCreateFolderError)

          expect {
            MediaResource.create_folder(@ben7th, '/大熊猫')
          }.to raise_error(MediaResource::RepeatedlyCreateFolderError)
        end

        it '当创建一个多级文件夹时，父文件夹被连带创建' do
          MediaResource.get(@ben7th, '/当归').should == nil
          MediaResource.get(@ben7th, '/当归/鹿茸').should == nil

          MediaResource.create_folder(@ben7th, '/当归/鹿茸/人参')

          MediaResource.get(@ben7th, '/当归').should_not == nil
          MediaResource.get(@ben7th, '/当归/鹿茸').should_not == nil
          MediaResource.get(@ben7th, '/当归/鹿茸/人参').should_not == nil
        end

        it '当创建一个多级文件夹时，父文件夹是已存在的文件，则将其覆盖' do
          MediaResource.get(@ben7th, '/大熊猫/三只熊猫.jpg').is_file?.should == true

          MediaResource.create_folder(@ben7th, '/大熊猫/三只熊猫.jpg/滚滚控')
          MediaResource.get(@ben7th, '/大熊猫').is_dir?.should == true
          MediaResource.get(@ben7th, '/大熊猫/三只熊猫.jpg').is_dir?.should == true
          MediaResource.get(@ben7th, '/大熊猫/三只熊猫.jpg/滚滚控').is_dir?.should == true
        end

        it '当创建文件夹时，指定路径是一个已被删除的资源，创建文件夹后，资源总数不变' do
          MediaResource.get(@ben7th, '/可乐').should == nil
          MediaResource.removed.root_res.find_by_name('可乐').should_not == nil

          count = MediaResource.count
          removed_count = MediaResource.removed.count

          MediaResource.create_folder(@ben7th, '/可乐').should == MediaResource.get(@ben7th, '/可乐')
          MediaResource.get(@ben7th, '/可乐').should_not == nil
          MediaResource.removed.root_res.find_by_name('可乐').should == nil
          MediaResource.count.should == count + 1
          MediaResource.removed.count.should == removed_count - 1
        end

        it '当传入无效路径时，不创建任何资源，也不抛异常' do
          count = MediaResource.count
          removed_count = MediaResource.removed.count

          MediaResource.create_folder(@ben7th, '/可\乐').should == nil
          MediaResource.create_folder(@ben7th, nil).should == nil
          MediaResource.create_folder(@ben7th, '/').should == nil
          MediaResource.create_folder(@ben7th, 'nl').should == nil

          MediaResource.count.should == count
          MediaResource.removed.count.should == removed_count
        end
      end
    end

    describe '读取信息' do
      it '能够从资源读取路径信息' do
        MediaResource.find_by_name('狗头.jpg').path.should == '/北极熊/企鹅/狗头.jpg'
        MediaResource.find_by_name('兔斯基.jpg.gif').path.should == '/北极熊/企鹅/兔斯基.jpg.gif'
      end

      it '能够读取文件和文件夹资源的META信息' do
        MediaResource.get(@ben7th, '/大熊猫').metadata(:list => false).should == {
          :bytes => 0,
          :is_dir => true,
          :path => '/大熊猫',
          :contents => []
        }

        MediaResource.get(@ben7th, '/大熊猫').metadata(:list => true).should == {
          :bytes => 0,
          :is_dir => true,
          :path => '/大熊猫',
          :contents => [
            {
              :bytes => 11, 
              :is_dir => false, 
              :path => '/大熊猫/三只熊猫.jpg', 
              :mime_type => "application/octet-stream"
            },
            {
              :bytes => 11, 
              :is_dir => false, 
              :path => '/大熊猫/倒挂.jpg',
              :mime_type => "application/octet-stream"
            },
            {
              :bytes => 0, 
              :is_dir => false, 
              :path => '/大熊猫/这是寂寞.jpg',
              :mime_type => 'application/octet-stream'
            }
          ]
        }

        MediaResource.get(@ben7th, '/大熊猫/三只熊猫.jpg').metadata.should == {
          :bytes => 11,
          :is_dir => false,
          :path => '/大熊猫/三只熊猫.jpg',
          :mime_type => "application/octet-stream"
        }
      end
    end

    describe '删除资源' do
      it '资源被删除后，fileops_time应该更新' do
        mr = MediaResource.get(@ben7th, '/大熊猫/这是寂寞.jpg')
        mr.fileops_time = 21.minutes.ago
        mr.save

        fileops_time = mr.fileops_time

        mr.remove

        mr.should be_is_removed
        mr.fileops_time.should_not == fileops_time
      end
    end

    describe '为指定用户创建资源' do
      file = Tempfile.new('test')

      before do
        MediaResource.all.each {|x| 
          x.fileops_time = 21.minutes.ago
          x.save
        }
        MediaResource.removed.each {|x|
          x.fileops_time = 21.minutes.ago
          x.save
        }
      end

      it '可以为指定用户创建资源' do
        MediaResource.get(@ben7th, '/可可西里.txt').should == nil
        MediaResource.put(@ben7th, '/可可西里.txt', file)
        MediaResource.get(@ben7th, '/可可西里.txt').should_not == nil
      end

      it '创建资源时必须指定用户，否则抛异常' do
        expect {
          MediaResource.put(nil, '/可可西里.txt', file)
        }.to raise_error(MediaResource::NotAssignCreatorError)
      end

      it '可以为不同的用户创建同名的资源' do
        count = MediaResource.count

        MediaResource.get(@ben7th, '/浪潮之巅.txt').should == nil
        MediaResource.get(@lifei,  '/浪潮之巅.txt').should == nil

        MediaResource.put(@ben7th, '/浪潮之巅.txt', file)
        MediaResource.put(@lifei,  '/浪潮之巅.txt', file)

        MediaResource.count.should == count + 2

        MediaResource.get(@ben7th, '/浪潮之巅.txt').should_not == nil
        MediaResource.get(@lifei,  '/浪潮之巅.txt').should_not == nil

        MediaResource.get(@ben7th, '/浪潮之巅.txt').id.should_not == MediaResource.get(@lifei,  '/浪潮之巅.txt').id
      end
    end

    describe '文件夹的文件计数' do

      file = Tempfile.new('test')

      it '文件夹会记录下面的文件计数' do
        MediaResource.get(@ben7th, '/大熊猫').is_dir?.should == true
        MediaResource.get(@ben7th, '/大熊猫').files_count.should == 3
      end

      it '对于上传的文件连带创建的父文件夹，文件计数是正确的' do
        MediaResource.put(@ben7th, '/小吃/花生.txt', file)
        MediaResource.get(@ben7th, '/小吃').files_count.should == 1

        MediaResource.put(@ben7th, '/饮料/矿泉水/农夫山泉.txt', file)

        MediaResource.get(@ben7th, '/饮料/矿泉水').is_dir?.should == true
        MediaResource.get(@ben7th, '/饮料/矿泉水').files_count.should == 1
        MediaResource.get(@ben7th, '/饮料').is_dir?.should == true
        MediaResource.get(@ben7th, '/饮料').files_count.should == 1

        MediaResource.put(@ben7th, '/饮料/可乐/百事可乐.txt', file)
        MediaResource.get(@ben7th, '/饮料/矿泉水').files_count.should == 1
        MediaResource.get(@ben7th, '/饮料/可乐').files_count.should == 1
        MediaResource.get(@ben7th, '/饮料').files_count.should == 2

        MediaResource.put(@ben7th, '/饮料/营养快线.txt', file)
        MediaResource.get(@ben7th, '/饮料/矿泉水').files_count.should == 1
        MediaResource.get(@ben7th, '/饮料/可乐').files_count.should == 1
        MediaResource.get(@ben7th, '/饮料').files_count.should == 3
      end

      it '对于已经删除的文件资源，其父文件夹的计数正确' do
        MediaResource.put(@ben7th, '/电影/文艺片/四月物语.rmvb', file)
        MediaResource.put(@ben7th, '/电影/喜剧片/疯狂的石头.rmvb', file)
        MediaResource.put(@ben7th, '/电影/喜剧片/疯狂的赛车.rmvb', file)

        MediaResource.get(@ben7th, '/电影').files_count.should == 3
        MediaResource.get(@ben7th, '/电影/文艺片').files_count.should == 1
        MediaResource.get(@ben7th, '/电影/喜剧片').files_count.should == 2

        MediaResource.get(@ben7th, '/电影/文艺片/四月物语.rmvb').remove

        MediaResource.get(@ben7th, '/电影').files_count.should == 2
        MediaResource.get(@ben7th, '/电影/文艺片').files_count.should == 0
        MediaResource.get(@ben7th, '/电影/喜剧片').files_count.should == 2

        MediaResource.get(@ben7th, '/电影/喜剧片').remove
        MediaResource.get(@ben7th, '/电影').files_count.should == 0
        MediaResource.get(@ben7th, '/电影/文艺片').files_count.should == 0
      end
    end

    describe '能够根据传入的 cursor(状态标识) 返回 delta(变更信息)' do
      file = Tempfile.new('test')

      it '测试例的变更信息应当正确' do
        delta = MediaResource.delta(@ben7th, nil)
        delta.should_not == nil
        delta[:entries].blank?.should == false
        path = delta[:entries][0][0]
        path.should == '/北极熊'
      end

      it '当传入的状态标识为零或空时，从开头开始返回变更信息，包括删除变更' do
        delta = MediaResource.delta(@ben7th, nil)
        delta.should_not == nil

        cursor = delta[:cursor]
        cursor.should_not == nil

        delta[:entries][0][0].should == '/北极熊'

        Timecop.travel(Time.now + 1.hours)
        MediaResource.put(@ben7th, '/游戏/网络游戏/魔兽世界.zip', file)
        delta = MediaResource.delta(@ben7th, cursor)
        delta[:entries].blank?.should == false
        delta[:entries].length.should == 3
        cursor_2 = delta[:cursor]

        delta[:entries][0].should == [
          '/游戏', 
          MediaResource.get(@ben7th, '/游戏').metadata(:list => false)
        ]
        delta[:entries][1].should == [
          '/游戏/网络游戏', 
          MediaResource.get(@ben7th, '/游戏/网络游戏').metadata(:list => false)
        ]
        delta[:entries][2].should == [
          '/游戏/网络游戏/魔兽世界.zip', 
          MediaResource.get(@ben7th, '/游戏/网络游戏/魔兽世界.zip').metadata
        ]

        Timecop.travel(Time.now + 1.hours)
        MediaResource.put(@ben7th, '/游戏/RPG游戏/空之轨迹FC.zip', file)

        delta_2 = MediaResource.delta(@ben7th, cursor)
        delta_2[:entries].blank?.should == false
        delta_2[:entries].length.should == 5

        delta_2 = MediaResource.delta(@ben7th, cursor_2)
        delta_2[:entries].blank?.should == false
        delta_2[:entries].length.should == 2
        cursor_3 = delta_2[:cursor]

        Timecop.travel(Time.now + 1.hours)
        MediaResource.get(@ben7th, '/游戏/RPG游戏').remove
        delta_3 = MediaResource.delta(@ben7th, cursor_3)
        delta_3[:entries].blank?.should == false
        delta_3[:entries].length.should == 2

      end

      it '删除文件导致的变更应该可以获取到，格式也应当正确' do
        cursor = MediaResource.delta(@ben7th, nil)[:cursor]

        Timecop.travel(Time.now + 1.hours)
        MediaResource.put(@ben7th, '/游戏/网络游戏/魔兽世界.zip', file)
        delta = MediaResource.delta(@ben7th, cursor)
        delta[:entries].blank?.should == false
        delta[:entries].length.should == 3
        cursor_2 = delta[:cursor]

        Timecop.travel(Time.now + 1.hours)
        MediaResource.get(@ben7th, '/游戏/网络游戏').remove
        delta_2 = MediaResource.delta(@ben7th, cursor_2)
        delta_2[:entries].blank?.should == false
        delta_2[:entries].length.should == 2

        delta_2[:entries][0].should == ['/游戏/网络游戏', nil]
        delta_2[:entries][1].should == ['/游戏/网络游戏/魔兽世界.zip', nil]
      end
      
      it '不同用户取得各自的delta信息时，不会冲突' do
        cursor_ben7th = MediaResource.delta(@ben7th, nil)[:cursor]
        cursor_lifei  = MediaResource.delta(@lifei, nil)[:cursor]

        cursor_ben7th.should_not == nil
        cursor_lifei.should == nil

        Timecop.travel(Time.now + 1.hours)
        MediaResource.put(@ben7th, '/小说/奇幻/冰与火之歌.zip', file)
        MediaResource.put(@lifei, '/电影/黑衣人.rmvb', file)
        delta_ben7th = MediaResource.delta(@ben7th, cursor_ben7th)
        delta_lifei  = MediaResource.delta(@lifei, cursor_lifei)

        delta_ben7th[:entries].length.should == 3
        delta_lifei[:entries].length.should == 2

        cursor_ben7th = delta_ben7th[:cursor]
        cursor_lifei  = delta_lifei[:cursor]

        Timecop.travel(Time.now + 1.hours)
        MediaResource.put(@lifei, '/电影/阿凡达2.rmvb', file)
        delta_ben7th = MediaResource.delta(@ben7th, cursor_ben7th)
        delta_lifei  = MediaResource.delta(@lifei, cursor_lifei)

        delta_ben7th[:entries].length.should == 0
        delta_lifei[:entries].length.should == 1
      end
    end
  end

  describe 'issue274' do
    before do
      @ben7th = User.create!(
        :login => 'ben7th',
        :name  => 'ben7th',
        :email => 'ben7th@sina.com',
        :password => '123456',
        :role     => :teacher
      )

      @dir_media_resource = MediaResource.create(
        :name    => '我是目录',
        :is_dir  => true,
        :creator => @ben7th,
        :media_resources => [
          MediaResource.new(
            :name => '子目录',
            :is_dir => true,
            :creator => @ben7th
          )
        ]
      )

    end

    it '目前在个人文件夹上传文件时，如果已经有同名文件，新上传的同名文件名字应该是这样 old_name(1) old_name(2)' do
      tmpfile = Tempfile.new('panda')
      tmpfile.write('hello world')

      file_entity = FileEntity.create(:attach => tmpfile)
      MediaResource.put_file_entity(@ben7th, '/我是目录/abc', file_entity)
      abc = MediaResource.last
      abc.name.should == 'abc'
      abc.path.should == '/我是目录/abc'

      file_entity = FileEntity.create(:attach => tmpfile)
      MediaResource.put_file_entity(@ben7th, '/我是目录/abc', file_entity)
      abc = MediaResource.last
      abc.name.should == 'abc(1)'
      abc.path.should == '/我是目录/abc(1)'

      file_entity = FileEntity.create(:attach => tmpfile)
      MediaResource.put_file_entity(@ben7th, '/我是目录/abc', file_entity)
      abc = MediaResource.last
      abc.name.should == 'abc(2)'
      abc.path.should == '/我是目录/abc(2)'

      file_entity = FileEntity.create(:attach => tmpfile)
      MediaResource.put_file_entity(@ben7th, '/abc', file_entity)
      abc = MediaResource.last
      abc.name.should == 'abc'
      abc.path.should == '/abc'

      file_entity = FileEntity.create(:attach => tmpfile)
      MediaResource.put_file_entity(@ben7th, '/abc', file_entity)
      abc = MediaResource.last
      abc.name.should == 'abc(1)'
      abc.path.should == '/abc(1)'

      file_entity = FileEntity.create(:attach => tmpfile)
      MediaResource.put_file_entity(@ben7th, '/abc', file_entity)
      abc = MediaResource.last
      abc.name.should == 'abc(2)'
      abc.path.should == '/abc(2)'

      file_entity = FileEntity.create(:attach => tmpfile)
      MediaResource.put_file_entity(@ben7th, '/我是目录/子目录/a.jpg', file_entity)
      abc = MediaResource.last
      abc.name.should == 'a.jpg'
      abc.path.should == '/我是目录/子目录/a.jpg'

      file_entity = FileEntity.create(:attach => tmpfile)
      MediaResource.put_file_entity(@ben7th, '/我是目录/子目录/a.jpg', file_entity)
      abc = MediaResource.last
      abc.name.should == 'a(1).jpg'
      abc.path.should == '/我是目录/子目录/a(1).jpg'

      file_entity = FileEntity.create(:attach => tmpfile)
      MediaResource.put_file_entity(@ben7th, '/我是目录/子目录/a.jpg', file_entity)
      abc = MediaResource.last
      abc.name.should == 'a(2).jpg'
      abc.path.should == '/我是目录/子目录/a(2).jpg'

      file_entity = FileEntity.create(:attach => tmpfile)
      a = MediaResource.put_file_entity(@ben7th, '/我是目录/子目录/a.jpg', file_entity)
      abc = MediaResource.last
      abc.name.should == 'a(3).jpg'
      abc.path.should == '/我是目录/子目录/a(3).jpg'
      a.should == abc
    end
  end


  describe 'issue243' do
    before do
      @ben7th = User.create!(
        :login => 'ben7th',
        :name  => 'ben7th',
        :email => 'ben7th@sina.com',
        :password => '123456',
        :role     => :teacher
      )

      tmpfile = Tempfile.new('panda')
      tmpfile.write('hello world')

      @dir_media_resource = MediaResource.create(
        :name    => '我是目录',
        :is_dir  => true,
        :creator => @ben7th,
        :media_resources => [
          MediaResource.new(
            :name => '三只熊猫.jpg', 
            :is_dir => false,
            :creator => @ben7th,
            :file_entity => FileEntity.new(:attach => tmpfile)
          ),
          MediaResource.new(
            :name => 'abc', 
            :is_dir => true,
            :creator => @ben7th
          )
        ]
      )

      @file_media_resource_1 = MediaResource.create(
        :name => '三只狼.jpg', 
        :is_dir => false,
        :creator => @ben7th,
        :file_entity => FileEntity.new(:attach => tmpfile)
      )

      @file_media_resource_2 = MediaResource.create(
        :name => '三只熊猫.jpg', 
        :is_dir => false,
        :creator => @ben7th,
        :file_entity => FileEntity.new(:attach => tmpfile)
      )

      @dir_media_resource_1 = MediaResource.create(
        :name => 'def', 
        :is_dir => true,
        :creator => @ben7th
      )

      @dir_media_resource_2 = MediaResource.create(
        :name => 'abc', 
        :is_dir => true,
        :creator => @ben7th
      )
    end

    it '移动资源（文件、目录）时，目标位置有同名资源（文件、目录）时，应当都不允许移动' do
      @file_media_resource_1.move('/我是目录').should == true
      @file_media_resource_1.dir.should == @dir_media_resource

      @dir_media_resource_1.move('/我是目录').should == true
      @dir_media_resource_1.dir.should == @dir_media_resource

      @file_media_resource_2.move('/我是目录').should == false
      @file_media_resource_2.valid?.should == false
      @file_media_resource_2.errors[:dir_id].blank?.should == false

      @dir_media_resource_2.move('/我是目录').should == false
      @dir_media_resource_2.valid?.should == false
      @dir_media_resource_2.errors[:dir_id].blank?.should == false

      @file_media_resource_1.move('').should == true
      @file_media_resource_1.dir_id.should == 0
      @file_media_resource_1.move('/我是目录').should == true
      @file_media_resource_1.move(nil).should == true
      @file_media_resource_1.dir_id.should == 0
      @file_media_resource_1.move('/我是目录').should == true
      @file_media_resource_1.move('/').should == true
      @file_media_resource_1.dir_id.should == 0
    end
  end

  describe 'issue202' do
    before do
      @ben7th = User.create!(
        :login => 'ben7th',
        :name  => 'ben7th',
        :email => 'ben7th@sina.com',
        :password => '123456',
        :role     => :teacher
      )

      @dir_media_resource = MediaResource.create(
        :name    => '我是目录',
        :is_dir  => true,
        :creator => @ben7th
      )

      tmpfile = Tempfile.new('panda')
      tmpfile.write('hello world')
      @file_media_resource_1 = MediaResource.create(
        :name => '三只熊猫.jpg', 
        :is_dir => false,
        :creator => @ben7th,
        :file_entity => FileEntity.new(:attach => tmpfile)
      )

      @file_media_resource_2 = MediaResource.create(
        :name => '三只狼.jpg', 
        :is_dir => false,
        :creator => @ben7th,
        :file_entity => FileEntity.new(:attach => tmpfile)
      )
    end

    it '个人资源目录 dir_id 字段没有增加校验' do
      @file_media_resource_1.dir_id = @dir_media_resource.id
      @file_media_resource_1.valid?.should == true

      @file_media_resource_1.dir_id = @file_media_resource_2.id
      @file_media_resource_1.valid?.should == false
      @file_media_resource_1.errors[:dir_id].blank?.should == false

      @file_media_resource_1.dir_id = -1
      @file_media_resource_1.valid?.should == false
      @file_media_resource_1.errors[:dir_id].blank?.should == false    
    end
  end
end
