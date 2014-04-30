function changeCohort(obj){
  selectedCohort = obj.options[obj.selectedIndex].value
  if(selectedCohort > 0){
    window.location = window.location.origin + '/teachers/dashboard?cohort=' + selectedCohort
  }
}