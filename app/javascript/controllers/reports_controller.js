import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["month", "year", "carrier", "reportContent", "shipmentDetailsModal", "shipmentDetailsTab", "shipmentDetailsTabContent", "savingsBreakdownModal", "savingsBreakdownTab", "savingsBreakdownTabContent"]

    connect() {
        console.log("Reports controller connected")
    }

    filter() {
        // In a real implementation, this would fetch filtered data from the server
        // For now, we'll just log the filter values
        const month = this.monthTarget.value
        const year = this.yearTarget.value
        const carrier = this.carrierTarget.value

        console.log(`Filtering reports by: Month: ${month}, Year: ${year}, Carrier: ${carrier}`)

        // This would typically trigger an AJAX request to refresh the report data
        // For example:
        // this.refreshReportData(month, year, carrier)
    }

    downloadInvoice() {
        // In a real implementation, this would trigger a download
        console.log("Downloading carrier invoice details")
    }

    openDistributionMapping() {
        console.log("Opening distribution mapping")
        // Would typically open a modal or navigate to a different view
    }

    openPackageProfile() {
        console.log("Opening package profile details")
        // Would typically open a modal or navigate to a different view
    }

    openZoneAnalysis() {
        console.log("Opening zone analysis")
        // Would typically open a modal or navigate to a different view
    }

    openTrackingSearch() {
        console.log("Opening tracking number search")
        // Would typically open a modal or navigate to a different view
    }

    // New methods for shipment details modal
    openShipmentDetailsModal() {
        console.log("Opening shipment details modal")
        this.shipmentDetailsModalTarget.classList.remove('hidden')
        document.body.classList.add('overflow-hidden')
    }

    closeShipmentDetailsModal() {
        console.log("Closing shipment details modal")
        this.shipmentDetailsModalTarget.classList.add('hidden')
        document.body.classList.remove('overflow-hidden')
    }

    // Savings breakdown modal methods
    openSavingsBreakdownModal() {
        console.log("Opening savings breakdown modal")
        this.savingsBreakdownModalTarget.classList.remove('hidden')
        document.body.classList.add('overflow-hidden')
    }

    closeSavingsBreakdownModal() {
        console.log("Closing savings breakdown modal")
        this.savingsBreakdownModalTarget.classList.add('hidden')
        document.body.classList.remove('overflow-hidden')
    }

    // Prevent click events from bubbling up to the backdrop
    stopPropagation(event) {
        event.stopPropagation()
    }

    switchShipmentDetailsTab(event) {
        const selectedTab = event.currentTarget.getAttribute('data-tab')
        console.log(`Switching to shipment details tab: ${selectedTab}`)

        // Stop event propagation to prevent modal from closing
        event.stopPropagation()

        // Update tab buttons
        this.shipmentDetailsTabTargets.forEach(tab => {
            if (tab.getAttribute('data-tab') === selectedTab) {
                tab.classList.remove('border-transparent', 'text-gray-500')
                tab.classList.add('border-blue-500', 'text-blue-600')
            } else {
                tab.classList.remove('border-blue-500', 'text-blue-600')
                tab.classList.add('border-transparent', 'text-gray-500')
            }
        })

        // Update tab content
        this.shipmentDetailsTabContentTargets.forEach(content => {
            if (content.getAttribute('data-tab-content') === selectedTab) {
                content.classList.remove('hidden')
                content.classList.add('block')
            } else {
                content.classList.remove('block')
                content.classList.add('hidden')
            }
        })
    }

    switchSavingsBreakdownTab(event) {
        const selectedTab = event.currentTarget.getAttribute('data-tab')
        console.log(`Switching to savings breakdown tab: ${selectedTab}`)

        // Stop event propagation to prevent modal from closing
        event.stopPropagation()

        // Update tab buttons
        this.savingsBreakdownTabTargets.forEach(tab => {
            if (tab.getAttribute('data-tab') === selectedTab) {
                tab.classList.remove('border-transparent', 'text-gray-500')
                tab.classList.add('border-blue-500', 'text-blue-600')
            } else {
                tab.classList.remove('border-blue-500', 'text-blue-600')
                tab.classList.add('border-transparent', 'text-gray-500')
            }
        })

        // Update tab content
        this.savingsBreakdownTabContentTargets.forEach(content => {
            if (content.getAttribute('data-tab-content') === selectedTab) {
                content.classList.remove('hidden')
                content.classList.add('block')
            } else {
                content.classList.remove('block')
                content.classList.add('hidden')
            }
        })
    }

    // This method would be used in a real implementation to refresh the report data
    // refreshReportData(month, year, carrier) {
    //   fetch(`/customer/reports/data?month=${month}&year=${year}&carrier=${carrier}`, {
    //     headers: {
    //       "Accept": "application/json",
    //       "X-Requested-With": "XMLHttpRequest"
    //     }
    //   })
    //   .then(response => response.json())
    //   .then(data => {
    //     // Update the report content with the new data
    //     // This would update various parts of the page with the returned data
    //   })
    //   .catch(error => {
    //     console.error("Error fetching report data:", error)
    //   })
    // }
} 