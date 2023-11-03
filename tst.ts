let setN = new Set<number>;
let num

num = 1;
setN.add(num);

num = 2.5;
setN.add(num);

num = undefined;
setN.add(num);
setN.add(1);
setN.add(1);
setN.add(1);

console.log(Array.from(setN));