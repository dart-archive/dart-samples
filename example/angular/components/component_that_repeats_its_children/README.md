# how can an Angular component repeat provided content

SO question: [Repeat over elements provided as content](http://stackoverflow.com/questions/21156950)

```
<my-component>
  <div>some provided content to repeat <span ng-bind="value.name">{{value.name}}</span></div>
</my-component>
```    

becomes

```
<my-component>
  <div>some provided content to repeat <span>1</span></div>
  <div>some provided content to repeat <span>2</span></div>
  <div>some provided content to repeat <span>3</span></div>
  <div>some provided content to repeat <span>4</span></div>
</my-component>

```

The component transcludes the provided child nodes into its shadowDOM to 
be able to repeat them.
The child nodes become part of <my-component> and aren't child nodes anymore.
