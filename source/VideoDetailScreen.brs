Function VideoDetailScreen(VideoID)
  content = getVideoDetail(VideoID)
  showVideoDetailScreen(content)
End Function

Function getVideoDetail(VideoID) as object
  request = CreateObject("roUrlTransfer")
  port = CreateObject("roMessagePort")
  request.SetMessagePort(port)
  request.SetRequest("GET")
  dlg = createObject("roOneLineDialog")
  dlg.setTitle("Seaching...")
  dlg.showBusyAnimation()
  dlg.show()

  request.SetUrl(Config().stagingUrl+"/api/video-details/?video="+VideoID)
  if (request.AsyncGetToString())
      while (true)
          msg = wait(0, port)
          if (type(msg) = "roUrlEvent")
              code = msg.GetResponseCode()
              if (code = 200)
              dlg.close()
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
                  o.Categories = CreateObject("roArray", 10, true)
                  for each category in json.tags
                    o.Categories.push(category.name)
                  end for
                  return o
              endif
          else if (event = invalid)
              request.AsyncCancel()
          endif
      end while
  endif
  return invalid

End Function

Function showVideoDetailScreen(content)
  port = CreateObject("roMessagePort")
   springBoard = CreateObject("roSpringboardScreen")
   springBoard.SetBreadcrumbText("Video", "Detail")
   springBoard.SetMessagePort(port)
   springBoard.addbutton(1,"Play")
   springBoard.SetStaticRatingEnabled(false)
   springBoard.SetContent(content)
   springBoard.Show()
   While True
       msg = wait(0, port)
       If msg.isScreenClosed() Then
           Return -1
       Elseif msg.isButtonPressed()
              if(msg.GetIndex() = 1)
                videoPlayer(content.ID)
              endif
           print "msg: "; msg.GetMessage(); "idx: "; msg.GetIndex()
       Endif
   End While
End Function
