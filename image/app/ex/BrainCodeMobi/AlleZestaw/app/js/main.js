
$(function() {
    var listTemplate = _.template($("#listTmp").text());
    var formTemplate = _.template($("#formTmp").text());

    $("#search").on("click", function() {
        //view waiting
        $("#list").html($("#waitingTmp").text());
        //prepare data
        var data = {}, i = 1, err = false;

        $("#form input").each(function(key, input) {
            var $input = $(input);
            if ($input.val() == "") {
                $input.addClass("error");
                $input.attr("placeholder", "Musisz wpisać nazwę przedmiotu");
                err = true;
            } else {
                data['product' + i] = $input.val();
                i++;
            }
        });
        if (err == true) {
            $("#list").empty();
            document.location = "#form";
            return;
        }
        //ajax
        $.ajax({
            type: "GET",
            url: "http://events.pozoga.eu/Ex/BrainCodeMobi/AlleZestaw/rest/",
            data: data
        }).done(function(json) {
            try {
                var data = JSON.parse(json);
                console.log(data);
                var html = listTemplate(data);
                $("#list").html(html);
            } catch (e) {
                console.log(e);
                $("#list").html($("#errorTmp").text());
            }
        }).fail(function() {
            $("#list").html($("#errorTmp").text());
        });
        document.location = "#list";
    });

    $("#addButton").on("click", function() {
        $("#form").append($(formTemplate({})));
    });

    $("#form").on("click", ".delButton", function() {
        var size = $("#form input").size();
        if (size <= 1)
            return;
        $(this).closest(".row").remove();
    });

    $("#form").on("keypress", "input", function() {
        $(this).removeClass("error");
    });

    $(document).keypress(function(e) {
        if (e.which == 13) {
            $("#search").trigger("click");
        }
    });


    $("#addButton").trigger("click").trigger("click");

});
