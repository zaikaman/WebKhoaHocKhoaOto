declare module 'docx' {
  export class Document {
    constructor(options: any);
  }
  
  export class Paragraph {
    constructor(options: any);
  }
  
  export class TextRun {
    constructor(text: string);
  }
  
  export class Packer {
    static toBlob(doc: Document): Promise<Blob>;
  }
} 