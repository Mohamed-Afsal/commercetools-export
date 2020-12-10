FROM centos:7

RUN yum update -y									 
RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash -				 
RUN yum -y install nodejs						 
RUN yum -y install git							 
#RUN git clone https://github.com/sphereio/sphere-node-product-csv-sync.git 
RUN git clone https://github.com/commercetools/nodejs.git		 
#RUN git clone https://github.com/sphereio/sphere-category-sync.git	  
#RUN npm install sphere-node-product-csv-sync --global			 
#  npm install  sphere-category-sync --global						&& \
RUN npm install @commercetools/category-exporter --global		 
RUN npm install @commercetools/price-exporter --global			 
RUN npm install @commercetools/product-exporter --global		 
RUN npm install @commercetools/inventories-exporter --global		

RUN mkdir -p /opt/ct-data/

