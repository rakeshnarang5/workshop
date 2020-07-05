<!DOCTYPE html>
<html>
<body>

<h2>JavaScript Numbers</h2>

<p>Extra large or extra small numbers can be written with scientific (exponential) notation:</p>

<p id="demo"></p>

<script>
var y = 123e5;
var z = 123e-5;
var j = 123e12

document.getElementById("demo").innerHTML =
y + "<br>" + z + "<br>" + j;
</script>

</body>
</html>
