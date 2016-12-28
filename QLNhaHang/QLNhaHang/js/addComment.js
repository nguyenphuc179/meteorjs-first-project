$(function () {
    $("#my-form").submit(function (e) {
        e.preventDefault();
        $.ajax({
            url: this.action,
            type: this.method,
            data: $(this).serialize(),
            success: function (data) {
                $("#result").prepend(data);
            }
        });
        $("#my-form").trigger("reset");
    });
});