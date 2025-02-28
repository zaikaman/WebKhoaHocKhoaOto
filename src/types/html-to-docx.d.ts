declare module '@rokt33r/html-to-docx' {
  export default function HTMLtoDOCX(
    html: string, 
    header?: string | null, 
    options?: object
  ): Promise<Blob>;
} 