import maplibregl from 'https://cdn.skypack.dev/maplibre-gl'

class MLMap extends HTMLElement {
	constructor() {
		super()
	}
	static observedAttributes = ["center.lat", "center.long"];
	attributeChangedCallback(name, oldValue, newValue) {
		console.log(`Attribute ${name} has changed.`);
	}




	connectedCallback() {
		const container = this

		// const shadow = this.attachShadow({ mode: "open" })
		// const container = document.createElement("div")
		// shadow.appendChild(container)
		// this.mapElement = container

		const center = this.attributes.center_long && this.attributes.center_lat && [
			parseFloat(this.attributes.center_long.value),
			parseFloat(this.attributes.center_lat.value)
		] || undefined

		this.map = new maplibregl.Map({
			// container: map_node,
			container,
			// style: "https://api.maptiler.com/maps/toner-v2/style.json",
			style: this.attributes.getNamedItem("map-style").value || "https://api.maptiler.com/maps/satellite/style.json",
			center: center || [ -71.057083, 42.361145,],
			zoom: this.attributes?.initZoom.value || 16,
		})


		this.map.on("load", () => {
			this.map.addSource('stops', {
				'type': 'geojson',
				'data': "/api/stops/geojson"
			})
			// Add a symbol layer
			this.map.addLayer({
				'id': 'stops',
				'type': 'circle',
				'source': 'stops',
				'paint': {
					// 'circle-radius': 12,
					'circle-radius': 1.2,
					'circle-color': '#111',
					// 'circle-color': '#ffc72c',
					'circle-stroke-color': '#ffc72c',
					// 'circle-stroke-color': '#222',
					'circle-stroke-width': 1,
			  },

				// 'layout': {
				// 		'icon-image': 'custom-marker',
				// 		// get the year from the source's "year" property
				// 		'text-field': ['get', 'year'],
				// 		'text-font': [
				// 			'Open Sans Semibold',
				// 			'Arial Unicode MS Bold'
				// 		],
				// 		'text-offset': [0, 1.25],
				// 		'text-anchor': 'top'
				// }
			});


		})

	}
}

customElements.define("ml-map", MLMap)

class MLMarker extends HTMLElement {
	constructor() {
		super()
	}

	static observedAttributes = ["lat", "long"];

	connectedCallback() {
		const center = this.attributes.long && this.attributes.lat && [
			parseFloat(this.attributes.long.value),
			parseFloat(this.attributes.lat.value)
		] || undefined

		console.debug(center)
		this.marker = new maplibregl.Marker()
			.setLngLat(center || [12.550343, 55.665957])
			.addTo(this.parentElement.map);

	}

}

// customElements.define("ml-marker", MLMarker)
