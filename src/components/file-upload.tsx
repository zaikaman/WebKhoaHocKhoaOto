import { useState, useRef } from 'react'
import { Button } from './ui/button'

interface FileUploadProps {
  accept: string
  onUpload: (file: File) => Promise<void>
  disabled?: boolean
}

export function FileUpload({ accept, onUpload, disabled }: FileUploadProps) {
  const [dragActive, setDragActive] = useState(false)
  const inputRef = useRef<HTMLInputElement>(null)

  function handleDrag(e: React.DragEvent) {
    e.preventDefault()
    e.stopPropagation()
    if (e.type === "dragenter" || e.type === "dragover") {
      setDragActive(true)
    } else if (e.type === "dragleave") {
      setDragActive(false)
    }
  }

  async function handleDrop(e: React.DragEvent) {
    e.preventDefault()
    e.stopPropagation()
    setDragActive(false)
    
    if (e.dataTransfer.files && e.dataTransfer.files[0]) {
      await onUpload(e.dataTransfer.files[0])
    }
  }

  async function handleChange(e: React.ChangeEvent<HTMLInputElement>) {
    e.preventDefault()
    if (e.target.files && e.target.files[0]) {
      await onUpload(e.target.files[0])
    }
  }

  return (
    <div
      className={`relative flex flex-col items-center justify-center min-h-[200px] ${
        dragActive ? "bg-primary/5" : ""
      }`}
      onDragEnter={handleDrag}
      onDragLeave={handleDrag}
      onDragOver={handleDrag}
      onDrop={handleDrop}
    >
      <input
        ref={inputRef}
        type="file"
        accept={accept}
        onChange={handleChange}
        className="hidden"
        disabled={disabled}
      />
      <Button
        type="button"
        variant="outline"
        disabled={disabled}
        onClick={() => inputRef.current?.click()}
      >
        Chọn file hoặc kéo thả vào đây
      </Button>
    </div>
  )
} 