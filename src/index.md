# DataViz World Indicators

```js
const data = await FileAttachment("net-national-income.csv").csv({
  typed: true,
});

const yearFieldsPattern = /^\d{4}\s\[YR\d{4}\]$/;

const yearFields = Object.keys(data[0] ?? {})
  .filter((key) => yearFieldsPattern.test(key))
  .reduce((result, fieldName) => {
    const year = parseInt(fieldName.slice(0, 4), 10);

    result[fieldName] = year;

    return result;
  }, {});

const sortedYearFields = Object.fromEntries(
  Object.entries(yearFields).toSorted(([_, yearA], [, yearB]) => yearA - yearB)
);

const country = view(
  Inputs.select(data, {
    label: "Country",
    format: (entry) => entry["Country Name"],
    value: data.find((entry) => entry["Country Code"] === "ITA"),
  })
);
```

```js
const formattedData = Object.entries(sortedYearFields).reduce(
  (result, [fieldName, year]) => {
    if (typeof country[fieldName] === "number") {
      result.push({
        year,
        income: country[fieldName],
      });
    }

    return result;
  },
  []
);

const maxIncome = Math.max(...formattedData.map((entry) => entry.income));

display(
  Plot.plot({
    marks: [
      Plot.lineY(formattedData, {
        x: "year",
        y: "income",
        tip: true,
      }),
    ],
  })
);
```
