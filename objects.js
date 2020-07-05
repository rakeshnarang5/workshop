<!DOCTYPE html>
<html>
<body>

<h2>JavaScript Objects</h2>

<p id="demo"></p>

<script>
var person = {
  firstName : "John",
  lastName  : "Doe",
  age     : 50,
  eyeColor  : "blue",
  gender: "Male"
};

document.getElementById("demo").innerHTML =
person.firstName + " is " + person.age + " years old, and gender of the person is: " + person.gender;
</script>

</body>
</html>
