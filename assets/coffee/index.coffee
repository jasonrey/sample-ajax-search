$ ->
    form = $ "#search"

    return if form.length is 0

    keyupDelay = 500
    keyupThrottle = null
    searchCounter = 0

    search = (string) ->
        dfd = $.Deferred()

        result = []

        result.push
            type: "type 1"
            link: "link 1"
            content: "content 1"

        result.push
            type: "type 2"
            link: "link 2"
            content: "content 2"

        result.push
            type: "type 3"
            link: "link 3"
            content: "content 3"

        setTimeout ->
            dfd.resolve result
        , 1500

        return dfd

    form.on "submit", (event) ->
        event.preventDefault()

    form.on "keyup", "input", (event) ->
        clearTimeout keyupThrottle

        $ "body > .search-result"
            .remove()

        input = $ @
        string = input.val()

        if string.length is 0
            $ "body > .search-loader"
                .remove()

            return

        searchLoader = $ "body > .search-loader"

        if searchLoader.length is 0
            loaderFrame = form.find ".search-loader"

            searchLoader = loaderFrame.clone()

            searchLoader
                .css
                    "width": input.outerWidth()
                    "top": input.offset().top + input.outerHeight()
                    "left": input.offset().left
                .appendTo $ "body"

        keyupThrottle = setTimeout ->
            internalCounter = ++searchCounter

            search string
                .done (response) ->
                    return if internalCounter isnt searchCounter

                    return if input.val().length is 0

                    resultFrame = form.find ".search-result"

                    searchResult = resultFrame.clone()

                    for r in response
                        block = $ "<li></li>"
                        block.html r.type + ": " + r.content

                        block.appendTo searchResult

                    searchLoader.remove()

                    if !input.is ":focus"
                        searchResult.css "display", "none"

                    searchResult
                        .css
                            "width": input.outerWidth()
                            "top": input.offset().top + input.outerHeight()
                            "left": input.offset().left
                        .appendTo $ "body"
        , keyupDelay

    $document = $ document

    $document.on "click", (event) ->
        target = $ event.target

        searchBounds = target.closest ".search-bounds"

        if searchBounds.length is 0
            $ "body > .search-loader"
                .hide()

            $ "body > .search-result"
                .hide()
        else
            $ "body > .search-loader"
                .show()

            $ "body > .search-result"
                .show()