$('.txtQuantity').on('keyup', function () {
    if (this.value < 1)
    { this.value = 1 }
    else
        if (this.value > 99)
        { this.value = 99 }
})