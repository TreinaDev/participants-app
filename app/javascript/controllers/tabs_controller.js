import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
export default class extends Controller {
  connect() {
    // Seleciona todas as abas e conteúdos
    const tabs = document.querySelectorAll(".tab-link");
    const contents = document.querySelectorAll(".tab-content");

    // Adiciona evento de clique nas abas
    tabs.forEach(tab => {
        tab.addEventListener("click", () => {
            // Remove classe ativa de todas as abas
            tabs.forEach(t => t.classList.remove("bg-violet-200"));
            // Esconde todo o conteúdo
            contents.forEach(content => content.classList.add("hidden"));

            // Ativa a aba clicada
            tab.classList.add("bg-violet-200");
            document.getElementById(tab.getAttribute("data-tab")).classList.remove("hidden");
        });
    });

    // Ativar a primeira aba por padrão
    tabs[0].classList.add("bg-violet-200");
  }
}
