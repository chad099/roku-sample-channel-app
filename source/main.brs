Function Main() as void
    screen = CreateObject("roListScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)

    'Initialize theme
    InitTheme()

    screen.SetHeader("Welcome to The Good News Media")
    screen.SetBreadcrumbText("Category", "Category")
    contentList = InitContentList()
    screen.SetContent(contentList)
    screen.show()

    while (true)
        msg = wait(0, port)
        if (type(msg) = "roListScreenEvent")
            if (msg.isListItemFocused())
                if(contentList[msg.GetIndex()].ID = "search")
                  screen.SetBreadcrumbText("Category", "Search")
                else
                  screen.SetBreadcrumbText("Category", contentList[msg.GetIndex()].Title)
                endif
            else if (msg.isListItemSelected())

                if(contentList[msg.GetIndex()].ID = "search")
                  SearchScreen()
                else
                  displayVideoLists(contentList[msg.GetIndex()].ID,contentList[msg.GetIndex()].Title)
                endif

            endif
        endif

    end while
End Function

Function getVideoCategoryList() as object
    request = CreateObject("roUrlTransfer")
    port = CreateObject("roMessagePort")
    request.SetMessagePort(port)
    request.SetRequest("GET")
    request.SetUrl(Config().stagingUrl+"/api/video-categories/")
    if (request.AsyncGetToString())
        while (true)
            msg = wait(0, port)
            if (type(msg) = "roUrlEvent")
                code = msg.GetResponseCode()
                if (code = 200)
                    categories = CreateObject("roArray", 10, true)
                    json = ParseJSON(msg.GetString())
                    temp = {
                        ID:"search"
                        Title: "Search Videos :"
                        SDSmallIconUrl: Config().searchIcon
                        HDSmallIconUrl: Config().searchIcon
                    }
                    categories.push(temp)
                    for each item in json
                        category = {
                            ID: item._id
                            Title: item.name
                        }
                        categories.push(category)
                    end for
                    return categories
                endif
            else if (event = invalid)
                request.AsyncCancel()
            endif
        end while
    endif
    return invalid
End Function

Function InitContentList() as object
      contentList = getVideoCategoryList()
      return contentList
End Function

Function displayVideoLists(categoryID, category) As Integer
    mPort=CreateObject("roMessagePort")
    poster = CreateObject("roPosterScreen")
    poster.SetBreadcrumbText("Videos", category)
    poster.SetMessagePort(mPort)
    'we can set the list style as
    'flat-category,arced-landscape,arced-portrait,flat-episodic
    poster.SetListStyle("arced-landscape")
    videos = getVideos(categoryID)
    poster.SetContentList(videos)
    poster.Show()

    while true
        msg = wait(0, poster.GetMessagePort())
        if type(msg) = "roPosterScreenEvent" then
            if msg.isListFocused() then
                categoryIndex=msg.GetIndex()
                print "current category index = ";categoryIndex
                print "current category = ";category[categoryIndex]
            else if msg.isListItemFocused() then
                print"You have focused"
                print"Category Index= "; categoryIndex
                print"Category Item index = "; msg.GetIndex()
                poster.SetBreadcrumbText("Video", videos[msg.GetIndex()].Title)
            else if msg.isListItemSelected() then
                print"You have selected"
                print"Category Index= "; categoryIndex
                print"Category Item index = "; msg.GetIndex()
                poster.SetBreadcrumbText("Video", videos[msg.GetIndex()].Title)
                VideoDetailScreen(videos[msg.GetIndex()].ID)
            else if msg.isScreenClosed() then
                print"Back button pressed"
                return -1
            end if
        end If
    end while
End Function

Function getVideos(categoryID) as object
  request = CreateObject("roUrlTransfer")
  port = CreateObject("roMessagePort")
  request.SetMessagePort(port)
  request.SetRequest("GET")
  dlg = createObject("roOneLineDialog")
  dlg.setTitle("Seaching...")
  dlg.showBusyAnimation()
  dlg.show()
  request.SetUrl(Config().stagingUrl+"/api/category-videos/?category="+categoryID)
  if (request.AsyncGetToString())
      while (true)
          msg = wait(0, port)
          if (type(msg) = "roUrlEvent")
              code = msg.GetResponseCode()
              if (code = 200)
              dlg.close()
                  videos = CreateObject("roArray", 10, true)
                  json = ParseJSON(msg.GetString())
                  for each item in json
                      video = {
                          ID: item._id
                          Title: item.title
                          ContentType: item.type
                          Description: item.description
                          Name: item.name
                          SDPosterUrl: item.thumbnail
                          HDPosterUrl: item.thumbnail
                          ShortDescriptionLine1: item.description
                          ShortDescriptionLine2: item.description
                      }
                      videos.push(video)
                  end for
                  return videos
              endif
          else if (event = invalid)
              request.AsyncCancel()
          endif
      end while
  endif
  return invalid
End Function
