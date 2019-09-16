FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
            file://Fix-build-when-ftp-feature-is-disabled.patch \
            file://Fix-build-without-features.cursor.patch \
            file://Protect-HSTS-code-for-no-feature-settings-build.patch \
"

PACKAGECONFIG_append = " libinput linuxfb no-opengl"
PACKAGECONFIG_DEFAULT = "udev widgets libs ltcg"
PACKAGECONFIG_SYSTEM = "libpng"

PACKAGECONFIG[ltcg] = "-ltcg"

# The creation of libQt5PrintSupport can currently not be avoided: https://bugreports.qt.io/browse/QTBUG-39634
QT_CONFIG_FLAGS += " \
    -no-feature-concurrent \
    -no-feature-openssl \
    -no-feature-printer \
    -no-feature-sql \
    -no-feature-vnc \
    -no-feature-xml \
"

# 5.10.1@6c6ace9d23f90845fd424e474d38fe30f070775e: configure --list-features
# abstractbutton .......... Widgets: Abstract base class of button widgets, providing functionality common to buttons.
# abstractslider .......... Widgets: Common super class for widgets like QScrollBar, QSlider and QDial.
# accessibility ........... Utilities: Provides accessibility support.
# action .................. Kernel: Provides widget actions.
# animation ............... Utilities: Provides a framework for animations.
# appstore-compliant ...... Disables code that is not allowed in platform app stores
# bearermanagement ........ Networking: Provides bearer management for the network stack.
# big_codecs .............. Internationalization: Supports big codecs, e.g. CJK.
# buttongroup ............. Widgets: Supports organizing groups of button widgets.
# calendarwidget .......... Widgets: Provides a monthly based calendar widget allowing the user to select a date.
# checkbox ................ Widgets: Provides a checkbox with a text label.
# clipboard ............... Kernel: Provides cut and paste operations.
# codecs .................. Internationalization: Supports non-unicode text conversions.
# colordialog ............. Dialogs: Provides a dialog widget for specifying colors.
# colornames .............. Painting: Supports color names such as "red", used by QColor and by some HTML documents.
# columnview .............. ItemViews: Provides a model/view implementation of a column view.
# combobox ................ Widgets: Provides drop-down boxes presenting a list of options to the user.
# commandlineparser ....... Utilities: Provides support for command line parsing.
# commandlinkbutton ....... Widgets: Provides a Vista style command link button.
# completer ............... Utilities: Provides completions based on an item model.
# concurrent .............. Kernel: Provides a high-level multi-threading API.
# contextmenu ............. Widgets: Adds pop-up menus on right mouse click to numerous widgets.
# cssparser ............... Kernel: Provides a parser for Cascading Style Sheets.
# cups .................... Painting: Provides support for the Common Unix Printing System.
# cursor .................. Kernel: Provides mouse cursors.
# datawidgetmapper ........ ItemViews: Provides mapping between a section of a data model to widgets.
# datestring .............. Data structures: Provides convertion between dates and strings.
# datetimeedit ............ Widgets: Supports editing dates and times.
# datetimeparser .......... Utilities: Provides support for parsing date-time texts.
# desktopservices ......... Utilities: Provides methods for accessing common desktop services.
# dial .................... Widgets: Provides a rounded range control, e.g., like a speedometer.
# dialog .................. Dialogs: Base class of dialog windows.
# dialogbuttonbox ......... Dialogs: Presents buttons in a layout that is appropriate for the current widget style.
# dirmodel ................ ItemViews: Provides a data model for the local filesystem.
# dockwidget .............. Widgets: Supports docking widgets inside a QMainWindow or floated as a top-level window on the desktop.
# dom ..................... File I/O: Supports the Document Object Model.
# draganddrop ............. Kernel: Supports the drag and drop mechansim.
# effects ................. Kernel: Provides special widget effects (e.g. fading and scrolling).
# errormessage ............ Dialogs: Provides an error message display dialog.
# filedialog .............. Dialogs: Provides a dialog widget for selecting files or directories.
# filesystemiterator ...... File I/O: Provides fast file system iteration.
# filesystemmodel ......... File I/O: Provides a data model for the local filesystem.
# filesystemwatcher ....... File I/O: Provides an interface for monitoring files and directories for modifications.
# fontcombobox ............ Widgets: Provides a combobox that lets the user select a font family.
# fontdialog .............. Dialogs: Provides a dialog widget for selecting fonts.
# formlayout .............. Widgets: Manages forms of input widgets and their associated labels.
# freetype ................ Fonts: Supports the FreeType 2 font engine (and its supported font formats).
# fscompleter ............. Utilities: Provides file name completion in QFileDialog.
# ftp ..................... Networking: Provides support for the File Transfer Protocol in QNetworkAccessManager.
# gestures ................ Utilities: Provides a framework for gestures.
# graphicseffect .......... Widgets: Provides various graphics effects.
# graphicsview ............ Widgets: Provides a canvas/sprite framework.
# groupbox ................ Widgets: Provides widget grouping boxes with frames.
# highdpiscaling .......... Kernel: Provides automatic scaling of DPI-unaware applications on high-DPI displays.
# http .................... Networking: Provides support for the Hypertext Transfer Protocol in QNetworkAccessManager.
# iconv ................... Internationalization: Provides internationalization on Unix.
# identityproxymodel ...... ItemViews: Supports proxying a source model unmodified.
# im ...................... Kernel: Provides complex input methods.
# image_heuristic_mask .... Images: Supports creating a 1-bpp heuristic mask for images.
# image_text .............. Images: Supports image file text strings.
# imageformat_bmp ......... Images: Supports Microsoft's Bitmap image file format.
# imageformat_jpeg ........ Images: Supports the Joint Photographic Experts Group image file format.
# imageformat_png ......... Images: Supports the Portable Network Graphics image file format.
# imageformat_ppm ......... Images: Supports the Portable Pixmap image file format.
# imageformat_xbm ......... Images: Supports the X11 Bitmap image file format.
# imageformat_xpm ......... Images: Supports the X11 Pixmap image file format.
# imageformatplugin ....... Images: Provides a base for writing a image format plugins.
# inputdialog ............. Dialogs: Provides a simple convenience dialog to get a single value from the user.
# itemmodel ............... ItemViews: Provides the item model for item views
# itemviews ............... ItemViews: Provides the model/view architecture managing the relationship between data and the way it is presented to the user.
# keysequenceedit ......... Widgets: Provides a widget for editing QKeySequences.
# label ................... Widgets: Provides a text or image display.
# lcdnumber ............... Widgets: Provides LCD-like digits.
# library ................. File I/O: Provides a wrapper for dynamically loaded libraries.
# lineedit ................ Widgets: Provides single-line edits.
# listview ................ ItemViews: Provides a list or icon view onto a model.
# listwidget .............. Widgets: Provides item-based list widgets.
# localserver ............. Networking: Provides a local socket based server.
# mainwindow .............. Widgets: Provides main application windows.
# mdiarea ................. Widgets: Provides an area in which MDI windows are displayed.
# menu .................... Widgets: Provides popup-menus.
# menubar ................. Widgets: Provides pull-down menu items.
# messagebox .............. Dialogs: Provides message boxes displaying informative messages and simple questions.
# mimetype ................ Utilities: Provides MIME type handling.
# movie ................... Images: Supports animated images.
# networkdiskcache ........ Networking: Provides a disk cache for network resources.
# networkinterface ........ Networking: Supports enumerating a host's IP addresses and network interfaces.
# networkproxy ............ Networking: Provides network proxy support.
# paint_debug ............. Painting: Enabled debugging painting with the environment variables QT_FLUSH_UPDATE and QT_FLUSH_PAINT.
# pdf ..................... Painting: Provides a PDF backend for QPainter.
# picture ................. Painting: Supports recording and replaying QPainter commands.
# printdialog ............. Dialogs: Provides a dialog widget for specifying printer configuration.
# printer ................. Painting: Provides a printer backend of QPainter.
# printpreviewdialog ...... Dialogs: Provides a dialog for previewing and configuring page layouts for printer output.
# printpreviewwidget ...... Widgets: Provides a widget for previewing page layouts for printer output.
# process ................. File I/O: Supports external process invocation.
# processenvironment ...... File I/O: Provides a higher-level abstraction of environment variables.
# progressbar ............. Widgets: Supports presentation of operation progress.
# progressdialog .......... Dialogs: Provides feedback on the progress of a slow operation.
# properties .............. Kernel: Supports scripting Qt-based applications.
# proxymodel .............. ItemViews: Supports processing of data passed between another model and a view.
# pushbutton .............. Widgets: Provides a command button.
# radiobutton ............. Widgets: Provides a radio button with a text label.
# regularexpression ....... Kernel: Provides an API to Perl-compatible regular expressions.
# resizehandler ........... Widgets: Provides an internal resize handler for dock widgets.
# rubberband .............. Widgets: Supports using rubberbands to indicate selections and boundaries.
# scrollarea .............. Widgets: Supports scrolling views onto widgets.
# scrollbar ............... Widgets: Provides scrollbars allowing the user access parts of a document that is larger than the widget used to display it.
# scroller ................ Widgets: Enables kinetic scrolling for any scrolling widget or graphics item.
# sessionmanager .......... Kernel: Provides an interface to the windowing system's session management.
# settings ................ File I/O: Provides persistent application settings.
# sha3-fast ............... Utilities: Optimizes SHA3 for speed instead of size.
# sharedmemory ............ Kernel: Provides access to a shared memory segment.
# shortcut ................ Kernel: Provides keyboard accelerators and shortcuts.
# sizegrip ................ Widgets: Provides corner-grips for resizing top-level windows.
# slider .................. Widgets: Provides sliders controlling a bounded value.
# socks5 .................. Networking: Provides SOCKS5 support in QNetworkProxy.
# sortfilterproxymodel .... ItemViews: Supports sorting and filtering of data passed between another model and a view.
# spinbox ................. Widgets: Provides spin boxes handling integers and discrete sets of values.
# splashscreen ............ Widgets: Supports splash screens that can be shown during application startup.
# splitter ................ Widgets: Provides user controlled splitter widgets.
# stackedwidget ........... Widgets: Provides stacked widgets.
# standarditemmodel ....... ItemViews: Provides a generic model for storing custom data.
# statemachine ............ Utilities: Provides hierarchical finite state machines.
# statusbar ............... Widgets: Supports presentation of status information.
# statustip ............... Widgets: Supports status tip functionality and events.
# stringlistmodel ......... ItemViews: Provides a model that supplies strings to views.
# style-stylesheet ........ Styles: Provides a widget style which is configurable via CSS.
# syntaxhighlighter ....... Widgets: Supports custom syntax highlighting.
# systemsemaphore ......... Kernel: Provides a general counting system semaphore.
# systemtrayicon .......... Utilities: Provides an icon for an application in the system tray.
# tabbar .................. Widgets: Provides tab bars, e.g., for use in tabbed dialogs.
# tabletevent ............. Kernel: Supports tablet events.
# tableview ............... ItemViews: Provides a default model/view implementation of a table view.
# tablewidget ............. Widgets: Provides item-based table views.
# tabwidget ............... Widgets: Supports stacking tabbed widgets.
# temporaryfile ........... File I/O: Provides an I/O device that operates on temporary files.
# textbrowser ............. Widgets: Supports HTML document browsing.
# textcodec ............... Internationalization: Supports conversions between text encodings.
# textdate ................ Data structures: Supports month and day names in dates.
# textedit ................ Widgets: Supports rich text editing.
# texthtmlparser .......... Kernel: Provides a parser for HTML.
# textodfwriter ........... Kernel: Provides an ODF writer.
# timezone ................ Utilities: Provides support for time-zone handling.
# toolbar ................. Widgets: Provides movable panels containing a set of controls.
# toolbox ................. Widgets: Provides columns of tabbed widget items.
# toolbutton .............. Widgets: Provides quick-access buttons to commands and options.
# tooltip ................. Widgets: Supports presentation of tooltips.
# topleveldomain .......... Utilities: Provides support for extracting the top level domain from URLs.
# translation ............. Internationalization: Supports translations using QObject::tr().
# treeview ................ ItemViews: Provides a default model/view implementation of a tree view.
# treewidget .............. Widgets: Provides views using tree models.
# udpsocket ............... Networking: Provides access to UDP sockets.
# undocommand ............. Utilities: Applies (redo or) undo of a single change in a document.
# undogroup ............... Utilities: Provides the ability to cluster QUndoCommands.
# undostack ............... Utilities: Provides the ability to (redo or) undo a list of changes in a document.
# undoview ................ Utilities: Provides a widget which shows the contents of an undo stack.
# validator ............... Widgets: Supports validation of input text.
# whatsthis ............... Widget Support: Supports displaying "What's this" help.
# wheelevent .............. Kernel: Supports wheel events.
# widgettextcontrol ....... Widgets: Provides text control functionality to other widgets.
# wizard .................. Dialogs: Provides a framework for multi-page click-through dialogs.
# xmlstream ............... Kernel: Provides a simple streaming API for XML.
# xmlstreamreader ......... Kernel: Provides a well-formed XML parser with a simple streaming API.
# xmlstreamwriter ......... Kernel: Provides a XML writer with a simple streaming API.
QT_CONFIG_FLAGS += " \
    -no-feature-bearermanagement \
    -no-feature-big_codecs \
    -no-feature-calendarwidget \
    -no-feature-clipboard \
    -no-feature-codecs \
    -no-feature-colordialog \
    -no-feature-columnview \
    -no-feature-combobox \
    -no-feature-commandlineparser \
    -no-feature-commandlinkbutton \
    -no-feature-completer \
    -no-feature-contextmenu \
    -no-feature-cups \
    -no-feature-cursor \
    -no-feature-datawidgetmapper \
    -no-feature-datetimeedit \
    -no-feature-datetimeparser \
    -no-feature-desktopservices \
    -no-feature-dial \
    -no-feature-dirmodel \
    -no-feature-dockwidget \
    -no-feature-dom \
    -no-feature-draganddrop \
    -no-feature-effects \
    -no-feature-errormessage \
    -no-feature-filedialog \
    -no-feature-filesystemmodel \
    -no-feature-filesystemwatcher \
    -no-feature-fontcombobox \
    -no-feature-fontdialog \
    -no-feature-formlayout \
    -no-feature-fscompleter \
    -no-feature-ftp \
    -no-feature-highdpiscaling \
    -no-feature-iconv \
    -no-feature-identityproxymodel \
    -no-feature-im \
    -no-feature-image_heuristic_mask \
    -no-feature-image_text \
    -no-feature-imageformat_bmp \
    -no-feature-imageformat_jpeg \
    -no-feature-imageformat_ppm \
    -no-feature-imageformat_xbm \
    -no-feature-imageformat_xpm \
    -no-feature-imageformatplugin \
    -no-feature-inputdialog \
    -no-feature-keysequenceedit \
    -no-feature-lcdnumber \
    -no-feature-lineedit \
    -no-feature-localserver \
    -no-feature-mdiarea \
    -no-feature-mimetype \
    -no-feature-movie \
    -no-feature-networkdiskcache \
    -no-feature-networkinterface \
    -no-feature-networkproxy \
    -no-feature-paint_debug \
    -no-feature-pdf \
    -no-feature-picture \
    -no-feature-printdialog \
    -no-feature-printpreviewdialog \
    -no-feature-printpreviewwidget \
    -no-feature-progressdialog \
    -no-feature-proxymodel \
    -no-feature-radiobutton \
    -no-feature-rubberband \
    -no-feature-sessionmanager \
    -no-feature-settings \
    -no-feature-sha3-fast \
    -no-feature-sharedmemory \
    -no-feature-shortcut \
    -no-feature-sizegrip \
    -no-feature-socks5 \
    -no-feature-sortfilterproxymodel \
    -no-feature-spinbox \
    -no-feature-standarditemmodel \
    -no-feature-statemachine \
    -no-feature-statusbar \
    -no-feature-statustip \
    -no-feature-stringlistmodel \
    -no-feature-syntaxhighlighter \
    -no-feature-systemsemaphore \
    -no-feature-systemtrayicon \
    -no-feature-tabbar \
    -no-feature-tabletevent \
    -no-feature-tableview \
    -no-feature-tablewidget \
    -no-feature-temporaryfile \
    -no-feature-textbrowser \
    -no-feature-textcodec \
    -no-feature-textedit \
    -no-feature-texthtmlparser \
    -no-feature-textodfwriter \
    -no-feature-toolbar \
    -no-feature-toolbox \
    -no-feature-tooltip \
    -no-feature-topleveldomain \
    -no-feature-treeview \
    -no-feature-treewidget \
    -no-feature-udpsocket \
    -no-feature-undocommand \
    -no-feature-undogroup \
    -no-feature-undostack \
    -no-feature-undoview \
    -no-feature-validator \
    -no-feature-whatsthis \
    -no-feature-wheelevent \
    -no-feature-wizard \
    -no-feature-xmlstream \
    -no-feature-xmlstreamreader \
    -no-feature-xmlstreamwriter \
"

QT_CONFIG_FLAGS += " \
    -no-feature-effects \
"

# Set QT_QPA_PLATFORM
QT_QPA_PLATFORM = "linuxfb"
QT_CONFIG_FLAGS += "-qpa ${QT_QPA_PLATFORM}"
