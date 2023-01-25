/*const fs = require("fs");
var loginInfo;
fs.readFile("./jsons/loginInfo.json", "utf8", (err, jsonString) => {
  if (err) {
    console.log("File read failed:", err);
    return;
  }
  try {
    loginInfo = JSON.parse(jsonString);

} catch (err) {
    console.log("Error parsing JSON string:", err);
  }
});
*/

const loginButton = document.getElementById("buttonLogin");

loginButton.addEventListener("click", (e) => {

    e.preventDefault();
    const username = document.getElementById("userLogin").value;
    const password = document.getElementById("passLogin").value;

    if (username === "a" && password === "a") {
        alert("You have successfully logged in.");
        location.reload();
    } else {

    loginErrorMsg.style.opacity = 1;
}
})


