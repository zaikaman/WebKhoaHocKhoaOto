"use client"

import { useEditor, EditorContent } from '@tiptap/react'
import StarterKit from '@tiptap/starter-kit'

interface EditorProps {
  name: string
  defaultValue?: string
}

// Helper function to strip HTML tags and get plain text
function stripHtmlTags(html: string): string {
  // Create a temporary DOM element to parse HTML
  if (typeof window !== 'undefined') {
    const tempDiv = document.createElement('div')
    tempDiv.innerHTML = html
    return tempDiv.textContent || tempDiv.innerText || ''
  }
  // Fallback for server-side rendering
  return html.replace(/<[^>]*>/g, '')
}

export function Editor({ name, defaultValue = '' }: EditorProps) {
  const editor = useEditor({
    extensions: [
      StarterKit,
    ],
    content: defaultValue,
    editorProps: {
      attributes: {
        class: 'prose prose-sm sm:prose lg:prose-lg xl:prose-2xl mx-auto focus:outline-none w-full min-h-[150px] px-3 py-2 border rounded-md',
      },
    },
  })

  // Update the hidden input value when content changes
  editor?.on('update', ({ editor }) => {
    const input = document.querySelector(`input[name="${name}"]`) as HTMLInputElement
    if (input) {
      // Get plain text instead of HTML
      const plainText = stripHtmlTags(editor.getHTML())
      input.value = plainText
    }
  })

  return (
    <div>
      <EditorContent editor={editor} />
      <input type="hidden" name={name} value={stripHtmlTags(editor?.getHTML() || '')} />
    </div>
  )
}
