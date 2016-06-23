Function InitTheme() as void
    app = CreateObject("roAppManager")
    primaryText                 = "#FFFFFF"
    secondaryText               = "#707070"
    'buttonText                  = "#C0C0C0"
    'buttonHighlight             = "#ffffff"
    backgroundColor             = "#e0e0e0"

    theme = {
        BackgroundColor: backgroundColor
        OverhangSliceHD: "pkg:/images/Overhang_Slice_HD.png"
        OverhangSliceSD: "pkg:/images/Overhang_Slice_HD.png"
        OverhangLogoHD: "pkg:/images/channel_logo.png"
        OverhangLogoSD: "pkg:/images/channel_logo.png"
        OverhangOffsetSD_X: "25"
        OverhangOffsetSD_Y: "15"
        OverhangOffsetHD_X: "25"
        OverhangOffsetHD_Y: "15"
        BreadcrumbTextLeft: "#37491D"
        BreadcrumbTextRight: "#E1DFE0"
        BreadcrumbDelimiter: "#37491D"
        'ThemeType: "generic-dark"
        ListItemText: secondaryText
        ListItemHighlightText: primaryText
        ListScreenDescriptionText: secondaryText
        ListItemHighlightHD: "pkg:/images/select_bkgnd.png"
        ListItemHighlightSD: "pkg:/images/select_bkgnd.png"
        GridScreenDescriptionRuntimeColor:"#5B005B"
        GridScreenDescriptionSynopsisColor:"#606000"
        GridScreenLogoHD:"pkg:/images/channel_logo.png"
        GridScreenOverhangSliceHD:"pkg:/images/Overhang_Slice_HD.png"
        GridScreenOverhangSliceSD:"pkg:/images/Overhang_Slice_HD.png"
        GridScreenOverhangHeightHD:"80"
        GridScreenOverhangHeightSD:"49"
    }
    app.SetTheme( theme )
End Function
