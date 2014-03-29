function checkEmail(id,email)
{
  var reg = /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
  if (reg.test(email)){
    return true; }
  else{
    alert('mail not valid');// here sending a message to the user
    document.getElementById(id).value="";
    document.getElementById(id).focus;
  }
}

function checkList(id)
{ 
  if(document.getElementById(id).value=='0')
  {
    alert("Please Select a Value from \"Action to Perform\" Dropdown");
    return false;
  }
  else
  return true;
}
