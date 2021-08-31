const initDropDownMenu = () => {
    const button = document.querySelector("#dropdownMenu2")
    const menu = document.querySelector("#dropdown-menu")
    button.addEventListener("click", () => {
        menu.classList.toggle("d-none")
    })
}
export { initDropDownMenu }