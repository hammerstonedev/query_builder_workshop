import { Controller } from 'stimulus'
export default class extends Controller {
  static values = {
  }

  connect() {
    const urlParams = new URLSearchParams(window.location.search)
    this.existingParams = urlParams
    this.paramsCache = {
      stable_id: urlParams.get('stable_id'),
      sort_by: urlParams.get('sort_by'),
      q: urlParams.get('q'),
      tab: urlParams.get('tab'),
    }
    this.existingParams.delete('stable_id')
    this.existingParams.delete('sort_by')
    this.existingParams.delete('q')
    this.existingParams.delete('tab')
    this.existingParams.delete('page')
    this.stableId = this.paramsCache['stable_id']
    this.storedFilterId = this.paramsCache['stored_filter_id']
    this.sortBy = this.paramsCache['sort_by']
    this.q = this.paramsCache['q']
    this.tab = this.paramsCache['tab']
  }

  updateSearch(event) {
    this.q = event.target.value
  }

  updateStableId(event) {
    const {
      detail: { stableId },
    } = event

    this.stableId = stableId
    this.storedFilterId = null
  }

  updateStoredFilter({ detail }) {
    const { storedFilterId } = detail
    this.storedFilterId = storedFilterId
    this.stableId = null
  }

  updateSort(event) {
    this.sortBy = event.target.value
    this.changeUrl()
  }

  changeUrl() {
    const params = new URLSearchParams()
    if (this.stableId) {
      params.append('stable_id', this.stableId)
    }
    if (this.storedFilterId) {
      params.append('stored_filter_id', this.storedFilterId)
    }
    const allParams = new URLSearchParams({
      ...Object.fromEntries(this.existingParams),
      ...Object.fromEntries(params),
    }).toString()
    const url = `${window.location.pathname}?${allParams}`
    history.pushState({}, document.title, url)
    window.location.reload()
  }

  search(event) {
    event.preventDefault()
    this.changeUrl()
    document.activeElement.blur()
  }
}
