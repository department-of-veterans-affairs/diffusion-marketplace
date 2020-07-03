// select the visn if the practice already has one
function selectVisn(originData, selectedVisn, visnSelector = '#editor_visn_select') {
    // based on the originData, which is the selected visn?
    debugger
    const visn = originData.visns.find(v => `${v.id}` === String(selectedVisn));
    const visnSelect = $(visnSelector);

    // select the visn and display it in the dropdown
    visnSelect.val(visn.id);
}