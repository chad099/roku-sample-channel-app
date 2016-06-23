Function videoPlayer(videoID)
  video =  getStreamData(videoID)
  playVideo(video)
End Function

Function getStreamData(videoID) As object
  request = CreateObject("roUrlTransfer")
  port = CreateObject("roMessagePort")
  request.SetMessagePort(port)
  request.SetRequest("GET")
  request.SetUrl(Config().stagingUrl+"/api/roku-media/?video="+VideoID)
  if (request.AsyncGetToString())
      while (true)
          msg = wait(0, port)
          if (type(msg) = "roUrlEvent")
              code = msg.GetResponseCode()
              if (code = 200)
                  json = ParseJSON(msg.GetString())
                  o = CreateObject("roAssociativeArray")
                  o.ID = json._id
                  o.ContentType = json.type
                  o.Title = json.title
                  o.ShortDescriptionLine1 = json.description
                  o.ShortDescriptionLine2 = json.description
                  o.Description = json.description
                  o.SDPosterUrl = json.thumbnail
                  o.HDPosterUrl = json.thumbnail
                  o.ReleaseDate = json.createdAt
                  o.Length = json.length
                  o.Stream = json.Stream.url
                  return o
              endif
          else if (event = invalid)
              request.AsyncCancel()
          endif
      end while
  endif
  return invalid

End Function

Function playVideo(video As Object)
  port = CreateObject("roMessagePort")
  screen = CreateObject("roVideoScreen")
  video.HDBranded = true
  video.IsHD = true
  video.Stream = {
      url:video.Stream
      bitrate:2000
      quality:true
      contentid: video.ID
      contented : "big-hls"
    }
  screen.SetContent(video)
  screen.SetMessagePort(port)
  screen.Show()
    while true
       msg = wait(0, port)
       if type(msg) = "roVideoScreenEvent" then
           print "showVideoScreen | msg = "; msg.GetMessage() " | index = "; msg.GetIndex()
           if msg.isScreenClosed()
               print "Screen closed"
               exit while
            else if msg.isStatusMessage()
                  print "status message: "; msg.GetMessage()
            else if msg.isPlaybackPosition()
                  print "playback position: "; msg.GetIndex()
                  nowpos = msg.GetIndex()
                RegWrite(episode.ContentId, nowpos.toStr())
            else if msg.isFullResult()
                  print "playback completed"
                  exit while
            else if msg.isPartialResult()
                  print "playback interrupted"
                  exit while
            else if msg.isRequestFailed()
                  print "request failed - error: "; msg.GetIndex();" - "; msg.GetMessage()
                  exit while
            end if
       end if
    end while
End Function
