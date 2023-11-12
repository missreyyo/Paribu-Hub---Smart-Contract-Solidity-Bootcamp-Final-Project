
function registerUser() {
    var userName = document.getElementById('userName').value;
    var userType = document.getElementById('userType').value;
  
    console.log('User Registered:', userName, userType);
  }
  
  function addProperty() {
    var propertyInfo = document.getElementById('propertyInfo').value;
    console.log('Property Added:', propertyInfo);
  }
  
  
  function startContract() {
    var propertyAddress = document.getElementById('propertyAddress').value;
    var startDate = document.getElementById('startDate').value;
    var endDate = document.getElementById('endDate').value;
  
  
    console.log('Contract Initiated:', propertyAddress, startDate, endDate);
  }
  
  
  function fileComplaint() {
    var complaintDescription = document.getElementById('complaintDescription').value;
  
    
    console.log('Complaint Filed:', complaintDescription);
  }