// http://www.bejson.com/ 解析json数据
//const serviceUrl='http://test.baixingliangfan.cn/baixing/';//2019-04-12失效
const serviceUrl='https://wxmini.baixingliangfan.cn/baixing/';//从群里那个github的地址找到的

const servicePath={
  'homePageContent':serviceUrl+'wxmini/homePageContent',//商店首页信息
  'homePageBelowConten':serviceUrl+'wxmini/homePageBelowConten',//商城首页热卖商品
  'getCategory':serviceUrl+'wxmini/getCategory',//商品类别信息
  'getMallGoods':serviceUrl+'wxmini/getMallGoods',//商品分类的商品列表
};