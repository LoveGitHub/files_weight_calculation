function checkEmail(id,email)
{
  var reg = /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
  if (reg.test(email)){
    return true; }
  else{
    alert('mail not valid');// here sending a message to the user
    document.getElementById(id).value="";
  }
}
