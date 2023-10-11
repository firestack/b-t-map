import maplibreGl from 'https://cdn.skypack.dev/maplibre-gl'

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
		await mapLoaded(this.closest("ml-map").map)
		this.parentElement.map.addSource(this.attributes.id.value, {
			'type': this.attributes.type.value,
			'data': this.attributes.src.value
		})
	}
}
customElements.define("ml-source", MLSource)

class MLLayer extends HTMLElement {
	async connectedCallback() {
		await mapLoaded(MLMap.getMap(this))

		this.parentElement.map.addLayer({
			'id': this.attributes.id.value,
			'type': 'circle',
			'source': this.attributes.source.value,
			'paint': {
				// 'circle-radius': 12,
				'circle-radius': 1.2,
				'circle-color': '#111',
				// 'circle-color': '#ffc72c',
				'circle-stroke-color': '#ffc72c',
				// 'circle-stroke-color': '#222',
				'circle-stroke-width': 1,
			},
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
