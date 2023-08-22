#!/usr/bin/env bash
# Copyright 2020 Google LLC
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -fueo pipefail
service=${1?no services provided eg: [redis|anthos|automl|cloudbuild]}

function list_services(){
  gcloud services list \
  2> /dev/null \
  | awk '/google/{print $1}'
}

function disable_service(){
  echo y | gcloud services disable $1 --force 2> /dev/null
  echo "- $1 disabled"
}

function enable_service(){
  echo "enabling service $1.googleapis.com"
  gcloud services enable $1.googleapis.com
}

function disable_all_services(){
  echo "disabling all services - (found $(list_services | wc -l))"
  list_services \
  | while read service; do
    disable_service $service
  done
  echo "$(list_services | wc -l) remaining"
}

disable_all_services
enable_service $service
echo "- the following services were enabled as a consequence of [$service]:"
list_services


# this list is not used, it's just for information purposes
all_services="""
abusiveexperiencereport
acceleratedmobilepageurl
accessapproval
accesscontextmanager
actions
adexchangebuyer
adexchangebuyer-json
adexchangeseller
adexperiencereport
admin
admob
adsense
adsensehost
alertcenter
analytics
analyticsreporting
androidcheck
androiddeviceprovisioning
androidenterprise
androidmanagement
androidovertheair
androidpublisher
anthos
anthosaudit
anthosconfigmanagement
anthosgke
apigee
apigeeconnect
appengine
appengineflex
appsactivity
appsmarket
appsmarket-component
arcorecloudanchor
area120tables
artifactregistry
audit
automl
bigquery
bigqueryconnection
bigquerydatatransfer
bigqueryreservation
bigquerystorage
bigtable
bigtableadmin
bigtabletableadmin
billingbudgets
binaryauthorization
blogger
books
caldav
calendar-json
carddav
chat
chromeuxreport
chromewebstore
civicinfo
classroom
cloudapis
cloudasset
cloudbilling
cloudbuild
clouddebugger
clouderrorreporting
cloudfunctions
cloudidentity
cloudiot
cloudkms
cloudlatencytest
cloudprivatecatalog
cloudprofiler
cloudresourcemanager
cloudscheduler
cloudsearch
cloudshell
cloudtasks
cloudtrace
composer
compute
computescanning
connectgateway
contacts
container
containeranalysis
containerregistry
containerscanning
containerthreatdetection
copresence
customsearch
datacatalog
dataflow
datafusion
datalabeling
dataproc
datastore
datastudio
deploymentmanager
dfareporting
dialogflow
digitalassetlinks
directions-backend
discovery
displayvideo
distance-matrix-backend
dlp
dns
docs
documentai
domainsrdap
doubleclickbidmanager
doubleclicksearch
drive
driveactivity
elevation-backend
embeddedassistant
endpoints
endpointsportal
factchecktools
fcm
fcmregistrations
file
firebase
firebaseappdistribution
firebaseapptesters
firebasedynamiclinks
firebaseextensions
firebasehosting
firebaseinappmessaging
firebaseinstallations
firebaseml
firebasemods
firebasepredictions
firebaseremoteconfig
firebaserules
firebasestorage
firestore
firewallinsights
fitness
games
gamesconfiguration
gameservices
gamesmanagement
genomics
geocoding-backend
geolocation
gkeconnect
gkehub
gmail
gmailpostmastertools
googleads
googlecloudmessaging
groupsmigration
groupssettings
healthcare
homegraph
iam
iamcredentials
iap
identitytoolkit
indexing
invoice
jobs
kgsearch
language
libraryagent
licensing
lifesciences
localservices
logging
managedidentities
manufacturers
maps-android-backend
maps-backend
maps-embed-backend
maps-ios-backend
mediatranslation
memcache
meshca
meshconfig
meshtelemetry
migrate
ml
mlkit
mobilecrashreporting
monitoring
moviesanywhere
multiclusteringress
multiclustermetering
networkmanagement
networkservices
networktopology
notebooks
orgpolicy
osconfig
oslogin
pagespeedonline
partners-json
people
performanceparameters
photoslibrary
picker
places-backend
playablelocations
playcustomapp
plus
plusdomains
plushangouts
policytroubleshooter
poly
prod-tt-sasportal
pubsub
pubsublite
realtime
realtimebidding
recommendationengine
recommender
redis
remotebuildexecution
replicapool
replicapoolupdater
reseller
resourceviews
risc
roads
run
runtimeconfig
safebrowsing
safebrowsing-json
sasportal
script
searchconsole
secretmanager
securetoken
securitycenter
serviceconsumermanagement
servicecontrol
servicedirectory
servicemanagement
servicenetworking
serviceusage
sheets
shoppingcontent
siteverification
slides
sourcerepo
spanner
speech
sql-component
sqladmin
stackdriver
static-maps-backend
storage
storage-api
storage-component
storagetransfer
street-view-image-backend
streetviewpublish
subscribewithgoogle
subscribewithgoogledeveloper
surveys
tagmanager
tasks
testing
texttospeech
threatdetection
timezone-backend
toolresults
tpu
trafficdirector
translate
travelpartner
usercontext
vault
vectortile
verifiedaccess
videointelligence
vision
vmmigration
vmwareengine
vpcaccess
walletobjects
webfonts
webmasters
websecurityscanner
workflowexecutions
workflows
youtube
youtubeanalytics
youtubereporting
zync
"""
