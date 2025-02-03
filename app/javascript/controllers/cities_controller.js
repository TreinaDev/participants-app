import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    
 async selectCity(event) {
     try {     
      const optionsCity = document.querySelector('.cities')
      optionsCity.innerHTML = ''
      const nameSate =  event.target.value
      const states = await fetch("https://brasilapi.com.br/api/ibge/uf/v1")
      const dataStates = await states.json()
      const uf = dataStates.find((state) => state.nome == nameSate).sigla
      const cities = await fetch(`https://brasilapi.com.br/api/ibge/municipios/v1/${uf}`)
      const dataCities = await cities.json()
      dataCities.forEach(city => {
        const option = document.createElement('option');
        option.textContent = city.nome;
        option.value = city.nome;
        optionsCity.appendChild(option);
      });
    } catch (error) {
      console.error('Erro ao carregar as cidades:', error);
    }
  }
}