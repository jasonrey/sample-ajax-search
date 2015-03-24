$ ->
    form = $ "#search"

    return if form.length is 0

    keyupDelay = 500
    keyupThrottle = null
    searchCounter = 0
    originalValue = ""
    lastClickWithinBounds = false

    action = form.attr "action"

    search = (string) ->
        dfd = $.Deferred()

        result = []

        result.push "type 1: content 1"
        result.push "type 2: content 2"
        result.push "type 3: content 3"
        result.push "type 4: content 4"

        setTimeout ->
            dfd.resolve result
        , 500

        return dfd

        return $.post action, string: string

    form.on "submit", (event) ->
        event.preventDefault()

    form.on "keyup", "input", (event) ->
        clearTimeout keyupThrottle

        input = $ @
        string = input.val()

        return if string is originalValue

        $ "body > .search-result"
        .remove()

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

            originalValue = string

            search string
            .done (response) ->
                return if internalCounter isnt searchCounter

                return if input.val().length is 0

                resultFrame = form.find ".search-result"
                resultItemFrame = form.find ".search-result-item"

                searchResult = resultFrame.clone()

                searchResult.empty()

                for r in response
                    block = resultItemFrame.clone()

                    block.html r

                    block.appendTo searchResult

                if not lastClickWithinBounds
                    searchResult.css "display", "none"

                searchResult
                .css
                    "width": input.outerWidth()
                    "top": input.offset().top + input.outerHeight()
                    "left": input.offset().left
                .appendTo $ "body"

                searchLoader.remove()
        , keyupDelay

    $ document
    .on "click", (event) ->
        target = $ event.target

        searchBounds = target.closest ".search-bounds"

        if searchBounds.length is 0
            $ "body > .search-loader"
            .hide()

            $ "body > .search-result"
            .hide()

            lastClickWithinBounds = false
        else
            $ "body > .search-loader"
            .show()

            $ "body > .search-result"
            .show()

            lastClickWithinBounds = true
