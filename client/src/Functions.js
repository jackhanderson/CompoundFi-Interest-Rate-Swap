export default function Swap(c1_rate, c2_rate, c1_apy, c2_apy) {
  const rate = [c1_rate, c2_rate];
  const apy = [c1_apy, c2_apy];
  const new_rate = [rate[0] * (1 + apy[0]), rate[1] * (1 + apy[1])];
  const new_val = [(1 / rate[0]) * new_rate[0], (1 / rate[1]) * new_rate[1]];

  const max = new_val.indexOf(Math.max(...new_val));
  const min = new_val.indexOf(Math.min(...new_val));

  const dif = new_val[max] - new_val[min];

  const exchange = (dif * 1) / new_rate[max];

  const final_min = 1 / rate[min];
  const final_max = 1 / rate[max] - exchange;

  if (min === 0) {
    const output = [
      { c1: final_min, c2: exchange },
      { c1: 0, c2: final_max },
    ];
    return output;
  } else {
    const output = [
      { c1: final_max, c2: 0 },
      { c1: exchange, c2: final_min },
    ];
    return output;
  }
}
