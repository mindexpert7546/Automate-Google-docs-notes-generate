function formatDocument() {
  const doc = DocumentApp.getActiveDocument();
  const body = doc.getBody();
  
  // First format all QUESTIONS (orange, size 20, bold)
  body.getParagraphs().forEach(paragraph => {
    const text = paragraph.getText().trim();
    if (text.match(/^\d+\.\s+.+\?/)) {
      paragraph.editAsText()
        .setBold(true)
        .setFontSize(20)
        .setForegroundColor("#f66c3b");
    }
  });

  // Now format ONLY the word "Answer:" (blue, size 16, bold)
  // Using a bulletproof text replacement approach
  const tempMarker = "☞☞TEMPORARY_MARKER☜☜";
  
  // Step 1: Replace "Answer:" with a unique temporary marker
  body.replaceText("Answer:", tempMarker);
  
  // Step 2: Replace back and format only during replacement
  let found = body.findText(tempMarker);
  while (found) {
    const element = found.getElement();
    const start = found.getStartOffset();
    const end = start + 6; // "Answer:" is 7 characters
    
    // Replace with formatted version
    element.asText()
      .deleteText(start, end)
      .insertText(start, "Answer:")
      .setBold(start, start + 6, true)
      .setFontSize(start, start + 6, 16)
      .setForegroundColor(start, start + 6, "#6671ff");
    
    found = body.findText(tempMarker, found);
  }
}