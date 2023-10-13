
/**
 * @param {HTMLElement} element
 */
export function parseValueFromType(element) {
	/** @type {"string" | "number"} */
	const type = element.attributes.type && element.attributes.type.value || "string"
	const value = element.attributes.value.value

	switch (type) {
		case "number":
			return Number.parseFloat(value)
		case "string":
		default:
			return value
	}
}

/**
 * @param {HTMLElement} element
 */
export function propertyName(element) {
	element.attributes.name.value
}

/**
 * @param {HTMLElement} element
 */
export function getProperties(element) {
	if (element) {
		return [...element.querySelectorAll("ml-property")]
			.reduce((prev, v) =>
				({ ...prev, [v.attributes.name.value]: parseValueFromType(v) }), {})
	}

	return {}
}
