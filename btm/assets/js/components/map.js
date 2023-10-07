import * as maplibre from "https://unpkg.com/maplibre-gl@3.4.0/dist/maplibre-gl.js?module"

class MLMap extends HTMLElement {
	constructor() {
		super()
	}
	
	connectedCallback() {
		console.debug('hi!!')
	}
}

customElements.define("ml-map", MLMap)