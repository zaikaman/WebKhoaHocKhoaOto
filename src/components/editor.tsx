"use client"

import { useEditor, EditorContent } from '@tiptap/react'
import StarterKit from '@tiptap/starter-kit'

interface EditorProps {
  name: string
  defaultValue?: string
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
      input.value = editor.getHTML()
    }
  })

  return (
    <div>
      <EditorContent editor={editor} />
      <input type="hidden" name={name} value={editor?.getHTML() || ''} />
    </div>
  )
}
