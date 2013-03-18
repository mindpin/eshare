jQuery ->
  r = new Resumable
    target : '/upload'
    testChunks : false # 不进行已上传块的测试
    simultaneousUploads : 1 # 一次上传一段
    chunkSize : 1024 * 512 # 512K 一段


  r.assignBrowse(jQuery('a.upload')[0])

  r.on 'fileAdded', (file)->
    r.upload()

  r.on 'fileProgress', (file)->
    console.log r