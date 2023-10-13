import maplibreGl from 'https://cdn.skypack.dev/maplibre-gl'
import { getProperties } from "./properties.js";

function whenLoaded(map, fn) {
	if (map.loaded()) {
		fn()
	} else {
		map.on("load", fn)
	}
}


async function mapLoaded(map) {
	return await (new Promise((resolve) => whenLoaded(map, resolve)))
}

class MLMap extends HTMLElement {
	async connectedCallback() {
		const container = this

		const center = this.attributes.center_long && this.attributes.center_lat && [
			parseFloat(this.attributes.center_long.value),
			parseFloat(this.attributes.center_lat.value)
		] || undefined

		this.map = new maplibreGl.Map({
			// container: map_node,
			container,
			// style: "https://api.maptiler.com/maps/toner-v2/style.json",
			style: this.attributes.getNamedItem("map-style").value || "https://api.maptiler.com/maps/satellite/style.json",
			center: center || [ -71.057083, 42.361145,],
			zoom: this.attributes?.initZoom.value || 16,
		})
	}

	/**
	 * @param {HTMLElement} self
	 */
	static getMap(self) {
		return self.closest("ml-map").map
	}
}
customElements.define("ml-map", MLMap)

class MLSource extends HTMLElement {
	async connectedCallback() {
		const map = MLMap.getMap(this);
		await mapLoaded(map)
		map.addSource(this.attributes.id.value, {
			'type': this.attributes.type.value,
			'data': this.attributes.src.value
		})
	}
}
customElements.define("ml-source", MLSource)

class MLLayer extends HTMLElement {
	async connectedCallback() {
		const map = MLMap.getMap(this);
		await mapLoaded(map)

		const paint = getProperties(this.querySelector("ml-layer-paint"))
		map.addLayer({
			'id': this.attributes.id.value,
			'type': this.attributes.type.value,
			'source': this.attributes.source.value,
			'layout': getProperties(this.querySelector("ml-layer-layout")),
			'paint': paint,
		});
	}
}
customElements.define("ml-layer", MLLayer)

class MLMarker extends HTMLElement {
	async connectedCallback() {
		const center = this.attributes.long && this.attributes.lat && [
			parseFloat(this.attributes.long.value),
			parseFloat(this.attributes.lat.value)
		] || undefined

		this.marker = new maplibreGl.Marker()
			.setLngLat(center);

		const map = MLMap.getMap(this)
		await mapLoaded(map)
		this.marker.addTo(map);
	}
}
customElements.define("ml-marker", MLMarker)
