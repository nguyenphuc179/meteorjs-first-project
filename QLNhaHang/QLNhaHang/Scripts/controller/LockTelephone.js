$('#Tel').on('change',function() {
    if (this.value.length > 8 && this.value.length < 16 && this.value > 0)
    { Errorsdt.style = 'display:none'; BtnSave.disabled = '' }
    else
    { Errorsdt.style = 'display:show'; BtnSave.disabled = 'disabled' }
})