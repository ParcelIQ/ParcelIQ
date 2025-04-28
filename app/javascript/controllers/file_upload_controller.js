import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["input", "filename", "uploadZone", "placeholder", "fileInfo"]

    connect() {
        if (this.hasFilenameTarget && this.filenameTarget.textContent.trim()) {
            this.showFileInfo()
        }

        // Set up drag and drop event listeners
        if (this.hasUploadZoneTarget) {
            this.uploadZoneTarget.addEventListener("dragenter", this.handleDragEnter.bind(this))
            this.uploadZoneTarget.addEventListener("dragleave", this.handleDragLeave.bind(this))
            this.uploadZoneTarget.addEventListener("dragover", this.handleDragOver.bind(this))
            this.uploadZoneTarget.addEventListener("drop", this.handleDrop.bind(this))
        }
    }

    disconnect() {
        // Clean up event listeners
        if (this.hasUploadZoneTarget) {
            this.uploadZoneTarget.removeEventListener("dragenter", this.handleDragEnter.bind(this))
            this.uploadZoneTarget.removeEventListener("dragleave", this.handleDragLeave.bind(this))
            this.uploadZoneTarget.removeEventListener("dragover", this.handleDragOver.bind(this))
            this.uploadZoneTarget.removeEventListener("drop", this.handleDrop.bind(this))
        }
    }

    handleFileSelect(event) {
        const input = event.target

        if (input.files && input.files[0]) {
            const fileName = input.files[0].name

            // Show file name in the UI
            if (this.hasFilenameTarget) {
                this.filenameTarget.textContent = fileName
            }

            // Visual indication that file is selected
            this.showFileInfo()

            // Add a success class to the upload zone
            if (this.hasUploadZoneTarget) {
                this.uploadZoneTarget.classList.remove('border-gray-300', 'border-dashed')
                this.uploadZoneTarget.classList.add('border-green-300', 'bg-green-50')
            }
        }
    }

    showFileInfo() {
        if (this.hasPlaceholderTarget && this.hasFileInfoTarget) {
            this.placeholderTarget.classList.add('hidden')
            this.fileInfoTarget.classList.remove('hidden')
        }
    }

    clearFile() {
        if (this.hasInputTarget) {
            this.inputTarget.value = ""

            if (this.hasFilenameTarget) {
                this.filenameTarget.textContent = ""
            }

            if (this.hasUploadZoneTarget) {
                this.uploadZoneTarget.classList.add('border-gray-300', 'border-dashed')
                this.uploadZoneTarget.classList.remove('border-green-300', 'bg-green-50')
            }

            if (this.hasPlaceholderTarget && this.hasFileInfoTarget) {
                this.placeholderTarget.classList.remove('hidden')
                this.fileInfoTarget.classList.add('hidden')
            }
        }
    }

    // Drag and drop handlers
    handleDragEnter(e) {
        e.preventDefault()
        e.stopPropagation()

        if (!this.hasFileInfoTarget || this.fileInfoTarget.classList.contains('hidden')) {
            this.uploadZoneTarget.classList.add('border-indigo-300', 'bg-indigo-50')
        }
    }

    handleDragOver(e) {
        e.preventDefault()
        e.stopPropagation()
    }

    handleDragLeave(e) {
        e.preventDefault()
        e.stopPropagation()

        if (!this.hasFileInfoTarget || this.fileInfoTarget.classList.contains('hidden')) {
            this.uploadZoneTarget.classList.remove('border-indigo-300', 'bg-indigo-50')
        }
    }

    handleDrop(e) {
        e.preventDefault()
        e.stopPropagation()

        this.uploadZoneTarget.classList.remove('border-indigo-300', 'bg-indigo-50')

        const dt = e.dataTransfer
        const files = dt.files

        if (files && files.length) {
            // Check if the file is a CSV
            if (files[0].name.toLowerCase().endsWith('.csv')) {
                // Set the file to the input
                this.inputTarget.files = files

                // Trigger the change event handler
                this.handleFileSelect({ target: this.inputTarget })
            } else {
                // Show an error for non-CSV files
                alert("Please upload a CSV file only.")
            }
        }
    }
} 