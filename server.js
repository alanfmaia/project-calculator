const express = require('express');
const app = express();
const PORT = 3000;

app.use(express.json());
app.use(express.static('public'));

app.post('/calculate', (req, res) => {
  const { expression } = req.body;

  try {
    // Safe math evaluation
    const sanitized = expression.replace(/[^0-9+\-*/().%\s]/g, '');
    if (!sanitized) return res.json({ error: 'Expressão inválida' });

    // Handle percentage
    const withPercent = sanitized.replace(/(\d+(?:\.\d+)?)%/g, '($1/100)');

    const result = Function('"use strict"; return (' + withPercent + ')')();

    if (!isFinite(result)) return res.json({ error: 'Erro: Divisão por zero' });

    res.json({ result: parseFloat(result.toPrecision(12)) });
  } catch (e) {
    res.json({ error: 'Expressão inválida' });
  }
});

app.listen(PORT, () => {
  console.log(`Calculadora rodando em http://localhost:${PORT}`);
});
