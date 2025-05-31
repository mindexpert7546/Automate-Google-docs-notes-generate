function formatDocument() {
  const doc = DocumentApp.getActiveDocument();
  const body = doc.getBody();
  
  // Format all QUESTIONS (number followed by dot and space)
  const paragraphs = body.getParagraphs();
  for (let i = 0; i < paragraphs.length; i++) {
    const paragraph = paragraphs[i];
    const text = paragraph.getText().trim();
    
    // Match patterns like: "10. Get the total number of employees."
    if (text.match(/^\d+\.\s+.+/)) {
      const textObj = paragraph.editAsText();
      textObj.setBold(0, text.length - 1, true);
      textObj.setFontSize(0, text.length - 1, 20);
      textObj.setForegroundColor(0, text.length - 1, "#f66c3b");
    }
    
    // Format SQL code blocks (lines starting with SQL or SELECT/INSERT/etc.)
    if (text.match(/^(SQL|SELECT|INSERT|UPDATE|DELETE|CREATE|COUNT)\b/i)) {
      const textObj = paragraph.editAsText();
      textObj.setFontFamily("Courier New");
      textObj.setBackgroundColor("#f5f5f5");
      textObj.setBold(false);
      textObj.setFontSize(12);
      textObj.setForegroundColor("#333333");
    }
    
    // Format the "SQL CopyEdit" line differently
    if (text.match(/^SQL\s*CopyEdit/i)) {
      const textObj = paragraph.editAsText();
      textObj.setFontSize(10);
      textObj.setForegroundColor("#999999");
    }
  }
  
  // Format ONLY the word "Answer:" (blue, size 16, bold)
  const tempMarker = "RAY_MARKER==RARY_MARKER==";
  body.replaceText("Answer:", tempMarker);
  
  let found = body.findText(tempMarker);
  while (found) {
    const element = found.getElement();
    const start = found.getStartOffset();
    element.asText()
      .deleteText(start, start + tempMarker.length - 1)
      .insertText(start, "Answer:")
      .setBold(start, start + 6, true)
      .setFontSize(start, start + 6, 16)
      .setForegroundColor(start, start + 6, "#6671ff");
    
    found = body.findText(tempMarker, found);
  }
}
