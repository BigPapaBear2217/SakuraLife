/* Utils */
const resName = GetParentResourceName()

// Fetch all the forms we want to apply custom Bootstrap validation styles to
var forms = document.querySelectorAll('.needs-validation')

// Loop over them and prevent submission
Array.prototype.slice.call(forms)
.forEach(function (form) {
	form.addEventListener('submit', function (event) {

	event.preventDefault();

	form.classList.add('was-validated')
	}, false)
})

function componentToHex(c) {
	var hex = c.toString(16);

	return hex.length == 1 ? "0" + hex : hex;
  }
  
function rgbToHex(r, g, b) {
	return "#" + componentToHex(r) + componentToHex(g) + componentToHex(b);
}  

function hexToRgb(hex) {
	var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);

	return result ? {
	  r: parseInt(result[1], 16),
	  g: parseInt(result[2], 16),
	  b: parseInt(result[3], 16)
	} : null;
}

function getVehicleLabel(vehicleModel, cb) {
	$.post(`https://${resName}/get-vehicle-label`, JSON.stringify({vehicleModel: vehicleModel}), cb)
}

function refresh() {
	$.post(`https://${resName}/get-jobs-data`, JSON.stringify({}), function (jobs) {
		fillJobs(jobs)
	}), "json";
}

// Disables enter
$(document).on("keypress", 'form', function (e) {
    var code = e.keyCode || e.which;
    if (code == 13) {
        e.preventDefault();
        return false;
    }
});

/* Dialogs */
function inputDialog(title, data, yesCallback) {
	$("#input-text-dialog-title").text(title);

	var inputModal = $("#input-text-dialog-modal");

	// Removes old data
	inputModal.find(".modal-body form").empty();

	data.forEach(currentData => {
		var id = currentData.id;
		var label = currentData.label;
		var defaultValue = currentData.default !== undefined ? currentData.default : "";

		var type = currentData.type || "text";

		if (type === "button") {
			var button = $(`<button type="button" class="mt-3 btn ${currentData.buttonType}">${label}</button>`);

			button.click(function () {
				currentData.buttonCallback(inputModal);
			});

			inputModal.find(".modal-body form").append(button);
		} else if (type === "select") {

			var select = $(`<select class="form-select" data-id="${id}" aria-label="Select"></select>`)
			var options = currentData.options

			options.forEach(option => {
				var optionElement = $(`<option value="${option.value}">${option.label}</option>`)
				select.append(optionElement);
			})

			inputModal.find(".modal-body form").append(select);
		} else if (type === "switch") {

			var switchInput = $(`
			<div class="form-check form-switch mt-3">
				<label class="form-check-label" for="modal-${id}">${label}</label>
				<input class="form-check-input" type="checkbox" id="modal-${id}" data-id="${id}">
			</div>`);

			inputModal.find(".modal-body form").append(switchInput);

			$(`#modal-${id}`).prop("checked", defaultValue)
		} else {
			let isAnId = currentData.isId || false
			var formGroup = $(
				`<div class="form-group">
					<label for="modal-${id}" class="col-form-label">${label}</label>
					<input id="modal-${id}" type="${type}" class="form-control" data-id="${id}" value="${defaultValue}">
					<div class="invalid-feedback">Can't be empty</div>
				</div>`
			)

			inputModal.find(".modal-body form").append(formGroup)

			let inputDiv = $(`#modal-${id}`);

			inputDiv.unbind('input');

			if(isAnId) {
				inputDiv.on('input', function() {
					let text = inputDiv.val();
					text = text.toLowerCase();
					text = text.replace(/[^a-zA-Z0-9]/g,'_');

					inputDiv.val(text);
				});
			}
		}
	})

	inputModal.modal("show");

	$("#input-text-dialog-confirm").off('click');
	$("#input-text-dialog-confirm").click(function () {
		var areInputsValid = true;

		var inputs = inputModal.find(".form-control, .form-select, :checkbox");
		var length = inputs.length;

		var data = {};

		inputs.each(function (index, element) {
			var text = $(element).val();
			if (text || $(element).is(":checkbox")) {
				$(element).removeClass("is-invalid");
				var id = $(element).data("id");

				if ($(element).is(":checkbox")) {
					data[id] = $(element).is(':checked');
				} else {
					data[id] = text;
				}

				if (index === (length - 1) && areInputsValid) {
					inputModal.modal("hide");
					yesCallback(data);
				}
			} else {
				$(element).addClass("is-invalid");
				areInputsValid = false;
			}
		})
	})
}

function deleteDialog(title, message, yesCallback) {
	var deleteModal = $('#delete-dialog-modal')
	deleteModal.find('.modal-title').text(title);
	deleteModal.find('.modal-body').text(message);

	deleteModal.modal("show")

	$("#delete-dialog-confirm").off('click');
	$("#delete-dialog-confirm").click(function () {
		deleteModal.modal("hide");
		yesCallback()
	})
}

function showError(msg){
	$("#notification-message").text(msg);
	$("#notification-modal").modal("show");
}

/* Ranks stuff */
function deleteRank(jobName, rankId) {
	deleteDialog("Delete rank", `Are you sure you want to delete this rank?`, function () {
		$.post(`https://${resName}/delete-rank`, JSON.stringify({ rankId: rankId }), function (data) {
			// Removes deleted row
			if (data.isSuccessful) {
				refreshJobRanks(jobName)
			} else {
				showError(data.message)
			}
		}), "json";
	})
}

function fillJobRanks(jobName, ranks) {
	var hasAnyRank = ranks.length > 0;

	var mainRankRow = $(`#main-rank-row-${jobName}`);
	// Removes old children
	mainRankRow.empty();

	var mainRowContent = $(`
		<th scope="col">Rank Name</th>
		<th scope="col">Rank Number</th>
		<th scope="col">Rank Label</th>
		<th scope="col">Salary</th>
	`)

	if (!hasAnyRank) {
		mainRowContent = $(`<th scope="col">No ranks for this job yet</th>`)
	}

	mainRankRow.append(mainRowContent);

	var rankRowTBody = $(`#rank-row-tbody-${jobName}`)
	// Removes old children
	rankRowTBody.empty();

	// Fills job ranks table
	ranks.forEach(rank => {
		var jobRank = $(`
			<tr id="job-rank-row-${rank.id}" class="job-rank-row">
				<th id="job-rank-name-${rank.id}" scope="row">${rank.name}</th>
				<td id="job-rank-grade-${rank.id}">${rank.grade}</td>
				<td id="job-rank-label-${rank.id}">${rank.label}</td>
				<td id="job-rank-salary-${rank.id}">${rank.salary}</td>
			</tr>
		`);

		rankRowTBody.append(jobRank);

		// Edits job rank
		jobRank.click(function () {
			inputDialog("Edit job rank", [
				{ id: "rankName", label: "Rank name:", default: rank.name, type: "text", isId: true },
				{ id: "rankGrade", label: "Rank grade:", default: rank.grade, type: "number" },
				{ id: "rankLabel", label: "Rank label:", default: rank.label, type: "text" },
				{ id: "rankSalary", label: "Rank salary:", default: rank.salary, type: "number" },
				{
					id: "deleteRank", label: "Delete rank", type: "button", buttonType: "btn-danger",
					buttonCallback: function (modal) {
						modal.modal("hide");
						deleteRank(jobName, rank.id);
					}
				},
			], function (data) {
				data.rankId = rank.id

				// Updates the rank
				$.post(`https://${resName}/update-rank`, JSON.stringify(data), function (resultData) {

					// Updates old row field with new values
					if (resultData.isSuccessful) {
						$(`#job-rank-name-${data.rankId}`).text(data.rankName);
						$(`#job-rank-grade-${data.rankId}`).text(data.rankGrade);
						$(`#job-rank-label-${data.rankId}`).text(data.rankLabel);
						$(`#job-rank-salary-${data.rankId}`).text(data.rankSalary);
					} else {
						showError(resultData.message)
					}
				});
			})
		})
	});
}

function refreshJobRanks(jobName) {
	$.post(`https://${resName}/retrieve-job-ranks`, JSON.stringify({ jobName: jobName }), function (ranks) {
		if (ranks) {
			fillJobRanks(jobName, ranks)
		}
	});
}

function createRank(jobName) {
	inputDialog("Create new rank", [
		{ id: "rankName", label: "Rank name (id):", type: "text", isId: true },
		{ id: "rankGrade", label: "Rank grade:", type: "number" },
		{ id: "rankLabel", label: "Rank label:", type: "text" },
		{ id: "rankSalary", label: "Rank salary:", type: "number" },
	], function (data) {
		data.jobName = jobName

		$.post(`https://${resName}/create-new-rank`, JSON.stringify(data), function (data) {
			if (data.isSuccessful) {
				refreshJobRanks(jobName)
			} else {
				showError(data.message)
			}
		});
	});
}

/* Job stuff */
$("#create-job-btn").click(function () {
	inputDialog("Create new job", [
		{ id: "jobLabel", label: "New job label:" },
		{ id: "jobName", label: "New job name (id):", isId: true },
	], function (data) {
		$.post(`https://${resName}/create-new-job`, JSON.stringify({ jobLabel: data.jobLabel, jobName: data.jobName }), function (data) {
			if (data.isSuccessful) {
				refresh()
			} else {
				showError(data.message)
			}
		});
	});
})

function deleteJob(jobName) {
	deleteDialog("Delete job", `Are you sure you want to delete ${jobName}?`, function () {
		$.post(`https://${resName}/delete-job`, JSON.stringify({ jobName: jobName }), function (data) {
			if (data.isSuccessful) {
				$(`#job-${jobName}`).remove();
			} else {
				showError(data.message)
			}
		});
	})
}

function fillJobs(jobs) {
	$("#jobs-container").empty();

	for (const [_, job] of Object.entries(jobs)) {
		let jobName = job.name;
		let jobLabel = job.label;

		var allJob = $(`
			<div data-jobname="${jobName}" data-joblabel="${jobLabel}" id="job-${jobName}" class="row">
				<!-- Job Button -->
				<div class="btn-group" role="group" aria-label="${jobLabel}">
					<button class="job-btn btn btn-success btn-lg col-11 mt-3" type="button" data-bs-toggle="collapse" data-bs-target="#job-collapse-${jobName}" aria-expanded="false" aria-controls="job-collapse-${jobName}">
						${jobLabel} - ${jobName}
					</button>

					<button type="button" class="btn btn-lg btn-success dropdown-toggle dropdown-toggle-split mt-3 col-sm-auto" data-bs-toggle="dropdown" aria-expanded="false">
						<span class="visually-hidden">Toggle Dropdown</span>
					</button>
					<div id="job-dropdown-${jobName}" data-jobname="${jobName}" class="dropdown-menu dropdown-menu-dark col-1"></div>
				</div>				

				<!-- Job Content -->
				<div class="collapse mt-2 col-12" id="job-collapse-${jobName}">
					<table class="table table-dark table-hover">
						<thead>
							<tr id="main-rank-row-${jobName}">
	
							</tr>
						</thead>
						<tbody class="rank-row-tbody" id="rank-row-tbody-${jobName}">

						</tbody>
					</table>
				</div>
			</div>
		`)

		allJob.data("enablebilling", job.enableBilling);
		allJob.data("canrob", job.canRob);
		allJob.data("canhandcuff", job.canHandcuff);
		allJob.data("whitelisted", job.whitelisted);
		allJob.data("canlockpickcars", job.canLockpickCars);
		allJob.data("canwashvehicles", job.canWashVehicles);
		allJob.data("canrepairvehicles", job.canRepairVehicles);
		allJob.data("canimpoundvehicles", job.canImpoundVehicles);
		allJob.data("cancheckidentity", job.canCheckIdentity);
		allJob.data("cancheckvehicleowner", job.canCheckVehicleOwner);
		allJob.data("cancheckdrivinglicense", job.canCheckDrivingLicense);
		allJob.data("cancheckweaponlicense", job.canCheckWeaponLicense);

		$("#jobs-container").append(allJob);

		var dropdownMarkers = $(`<a class="dropdown-item" href="#">Markers</a>`)
		var dropdownEditJob = $(`<a class="dropdown-item" href="#">Edit Job</a>`)
		var dropdownCreateRank = $(`<a class="dropdown-item" href="#">Create Rank</a>`)

		dropdownMarkers.click(function () {
			var mainJobDiv = $(this).parent().parent().parent()
			var jobName = mainJobDiv.data("jobname");
			var jobLabel = mainJobDiv.data("joblabel");

			openJobMarkers(jobName, jobLabel);
		})

		dropdownEditJob.click(function () {
			let mainJobDiv = $(this).parent().parent().parent()
			let jobName = mainJobDiv.data("jobname");
			let jobLabel = mainJobDiv.data("joblabel");
			let enableBilling = mainJobDiv.data("enablebilling");
			let canRob = mainJobDiv.data("canrob");
			let canHandcuff = mainJobDiv.data("canhandcuff");
			let whitelisted = mainJobDiv.data("whitelisted");
			let canLockpickCars = mainJobDiv.data("canlockpickcars");
			let canWashVehicles = mainJobDiv.data("canwashvehicles");
			let canRepairVehicles = mainJobDiv.data("canrepairvehicles");
			let canImpoundVehicles = mainJobDiv.data("canimpoundvehicles");
			let canCheckIdentity = mainJobDiv.data("cancheckidentity");
			let canCheckVehicleOwner = mainJobDiv.data("cancheckvehicleowner");
			let canCheckDrivingLicense = mainJobDiv.data("cancheckdrivinglicense");
			let canCheckWeaponLicense = mainJobDiv.data("cancheckweaponlicense");

			inputDialog("Edit job", [
				{ id: "jobName", label: "Job name (id):", default: jobName, type: "text", isId: true },
				{ id: "jobLabel", label: "Job label:", default: jobLabel, type: "text" },
				{ id: "enableBilling", label: "Enable billing", default: enableBilling, type: "switch" },
				{ id: "canRob", label: "Can rob/search players?", default: canRob, type: "switch" },
				{ id: "canHandcuff", label: "Can handcuff players?", default: canHandcuff, type: "switch" },
				{ id: "whitelisted", label: "Whitelisted", default: whitelisted, type: "switch" },
				{ id: "canLockpickCars", label: "Can lockpick cars?", default: canLockpickCars, type: "switch" },
				{ id: "canWashVehicles", label: "Can wash vehicles?", default: canWashVehicles, type: "switch" },
				{ id: "canRepairVehicles", label: "Can repair vehicles?", default: canRepairVehicles, type: "switch" },
				{ id: "canImpoundVehicles", label: "Can impound vehicles?", default: canImpoundVehicles, type: "switch" },
				{ id: "canCheckIdentity", label: "Can check identities?", default: canCheckIdentity, type: "switch" },
				{ id: "canCheckVehicleOwner", label: "Can check vehicle owner?", default: canCheckVehicleOwner, type: "switch" },
				{ id: "canCheckDrivingLicense", label: "Can check driving license?", default: canCheckDrivingLicense, type: "switch" },
				{ id: "canCheckWeaponLicense", label: "Can check weapon license?", default: canCheckWeaponLicense, type: "switch" },
				// Delete job button
				{
					id: "deleteJob", label: "Delete job", type: "button", buttonType: "btn-danger",
					buttonCallback: function (modal) {
						modal.modal("hide");
						deleteJob(jobName);
					}
				},
			], function (data) {
				data.oldJobName = jobName

				// Updates the job
				$.post(`https://${resName}/update-job`, JSON.stringify(data), function (resultData) {

					// Updates old job with new values
					if (resultData.isSuccessful) {

						// Changes text in main job div
						$(mainJobDiv).find(".job-btn").html(`${data.jobLabel} - ${data.jobName}`);

						// Updates jobname and joblabel in main job div
						mainJobDiv.data("jobname", data.jobName);
						mainJobDiv.data("joblabel", data.jobLabel);
						mainJobDiv.data("enablebilling", data.enableBilling);
						mainJobDiv.data("canrob", data.canRob);
						mainJobDiv.data("canhandcuff", data.canHandcuff);
						mainJobDiv.data("whitelisted", data.whitelisted);
						mainJobDiv.data("canlockpickcars", data.canLockpickCars);
						mainJobDiv.data("canwashvehicles", data.canWashVehicles);
						mainJobDiv.data("canrepairvehicles", data.canRepairVehicles);
						mainJobDiv.data("canimpoundvehicles", data.canImpoundVehicles);
						mainJobDiv.data("cancheckidentity", data.canCheckIdentity);
						mainJobDiv.data("cancheckvehicleowner", data.canCheckVehicleOwner);
						mainJobDiv.data("cancheckdrivinglicense", data.canCheckDrivingLicense);
						mainJobDiv.data("cancheckweaponlicense", data.canCheckWeaponLicense);

					} else {
						showError(resultData.message)
					}
				});
			})
		})

		dropdownCreateRank.click(function () {
			var mainJobDiv = $(this).parent().parent().parent()
			var jobName = mainJobDiv.data("jobname");

			createRank(jobName)
		})

		$(`#job-dropdown-${jobName}`).append(dropdownMarkers, dropdownEditJob, dropdownCreateRank);

		fillJobRanks(job.name, job.ranks);
	}
}

function addVehicleToTemporaryGarage(vehicleModel, vehicleData) {
	vehicleData = vehicleData || {}

	let vehiclesTable = $("#garage-data-model-tbody")
	
	let vehiclePrimaryColor = vehicleData.primaryColor || "#111111"
	let vehicleSecondaryColor = vehicleData.secondaryColor || "#111111"

	let deleteVehicleBtn = $(`<button class="btn btn-outline-danger" type="button">Delete</button>`)
	
	let vehicleTableRow = $(`
		<tr class="vehicle">
			<th scope="row">
				<p class="text-center vehicle-model">${vehicleModel}</p>
			</th>
			<td>
				<p class="text-center vehicle-label">${vehicleModel}</p>
			</td>
			<td>
				<input type="color" class="form-control form-control-color vehicle-primary-color" value="${vehiclePrimaryColor}" title="Primary Color">
			</td>
			<td>
				<input type="color" class="form-control form-control-color vehicle-secondary-color" value="${vehicleSecondaryColor}" title="Secondary Color">
			</td>
			<td class="delete-vehicle-btn"/>
		</tr>
	`)

	getVehicleLabel(vehicleModel, (vehicleLabel) => {
		vehicleTableRow.find(".vehicle-label").text(vehicleLabel)
	})

	vehiclesTable.append(vehicleTableRow);

	vehicleTableRow.find(".delete-vehicle-btn").append(deleteVehicleBtn)

	$(deleteVehicleBtn).click(function () {
		$(this).parents(".vehicle").remove();
	});
}

/* Markers */
function openMarkerData(markerId, type) {
	let rawData = $(`#marker-row-id-${markerId}`).data("data")

	if(typeof(rawData) == "string") {
		var data = JSON.parse(rawData)
	} else {
		var data = rawData || {}
	}

	switch (type) {
		case "garage": {
			$("#garage-data-modal").data("markerId", markerId);

			var coords = data.spawnCoords

			if (coords) {
				$("#marker-data-spawnpoint-x").val(coords.x)
				$("#marker-data-spawnpoint-y").val(coords.y)
				$("#marker-data-spawnpoint-z").val(coords.z)
			}

			if (data.heading) {
				$("#marker-data-heading").val(data.heading)
			}

			$("#garage-data-model-tbody").empty();

			if (data.vehicles) {
				for (const [vehicleModel, vehicleData] of Object.entries(data.vehicles)) {
					addVehicleToTemporaryGarage(vehicleModel, vehicleData)
				}
			}

			$("#garage-data-modal").modal("show");
			break;
		}

		case "boss": {
			$("#boss-data-modal").data("markerId", markerId);

			var canWashMoney = data.canWashMoney;
			var canWithdraw = data.canWithdraw;
			var canDeposit = data.canDeposit;
			var canEmployees = data.canEmployees;
			var canGrades = data.canGrades;

			if(canWashMoney) {
				$("#boss-data-washmoney-percentage").val(data.washMoneyReturnPercentage);
				$("#boss-data-washmoney-to-society-account").prop("checked", data.washMoneyGoesToSocietyAccount);
				$("#boss-data-washmoney-data").show();
			} else {
				$("#boss-data-washmoney-data").hide();
			}

			$("#boss-data-washmoney").prop('checked', canWashMoney);
			$("#boss-data-withdraw").prop('checked', canWithdraw);
			$("#boss-data-deposit").prop('checked', canDeposit);
			$("#boss-data-employees").prop('checked', canEmployees);
			$("#boss-data-grades").prop('checked', canGrades);

			$("#boss-data-modal").modal("show");

			break;
		}

		case "stash": {
			deleteDialog("Stash inventory", "Do you want to delete this stash's content?", function () {
				$.post(`https://${resName}/delete-stash-inventory`, JSON.stringify({ markerId: markerId }), function (data) {
					if(!data.isSuccessful) {
						showError(data.message)
					}
				})
			})
			break;
		}

		case "shop": {
			$("#shop-data-modal").data("markerId", markerId);

			$("#shop-data-item-id").val("")
			$("#shop-data-item-price").val("")

			$('#shop-data-items-container').empty();

			if (data.itemsOnSale) {
				for (const [itemName, itemData] of Object.entries(data.itemsOnSale)) {
					addItemToShop(itemName, itemData)
				}
			}

			$("#shop-data-modal").modal("show");
			break;
		}

		case "garage_buyable": {
			$("#garage-buyable-data-modal").data("markerId", markerId);
			
			if(data.spawnCoords) {
				if(data.spawnCoords.x) {
					$("#garage-buyable-spawnpoint-x").val(data.spawnCoords.x);
				}
	
				if(data.spawnCoords.y) {
					$("#garage-buyable-spawnpoint-y").val(data.spawnCoords.y);
				}
	
				if(data.spawnCoords.z) {
					$("#garage-buyable-spawnpoint-z").val(data.spawnCoords.z);
				}
			}

			if(data.heading) {
				$("#garage-buyable-heading").val(data.heading);
			}

			$("#garage-buyable-vehicles").empty();

			if(data.vehicles) {
				for (const [vehicleName, price] of Object.entries(data.vehicles)) {
					var vehicleInputGroup = $(`<div class="input-group mt-1 vehicle"></div>`)

					var vehicleInput = $(`<input type="text" class="form-control vehicle-model" placeholder="Vehicle model" disabled value="${vehicleName}">`);
					var moneySpan = $(`<span class="input-group-text">$</span>`)
					var vehiclePrice = $(`<input type="text" class="form-control vehicle-price" placeholder="Vehicle price" disabled value="${price}">`);
					var deleteVehicle = $(`<button class="btn btn-outline-danger" type="button">Delete</button>`);

					vehicleInputGroup.append(vehicleInput, moneySpan, vehiclePrice, deleteVehicle);

					$(deleteVehicle).click(function () {
						$(this).parent().remove();
					})

					$("#garage-buyable-vehicles").append(vehicleInputGroup)
				}
			}
			
			$("#garage-buyable-vehicle-model").val("");
			$("#garage-buyable-vehicle-price").val("");

			$("#garage-buyable-data-modal").modal("show");
			break;
		}

		case 'crafting_table': {
			$("#crafting-table-data-modal").data("markerId", markerId);

			var craftablesDiv = $("#craftables")

			craftablesDiv.empty();

			if(data.craftablesItems) {
				for (const [resultItemName, craftingData] of Object.entries(data.craftablesItems)) {
					addNewCraftableToCraftables(resultItemName, craftingData)
				}
			}

			$("#crafting-table-data-modal").modal("show");
			break;
		}

		case 'armory': {
			let armoryDataModal = $("#armory-data-modal");

			armoryDataModal.data("markerId", markerId);

			let isSharedSwitch = $("#armory-is-shared")
			let refillOnTakeSwitch = $("#armory-refill-on-take");
		
			isSharedSwitch.prop("checked", data.isShared);
			refillOnTakeSwitch.prop("checked", data.refillOnTake);

			armoryDataModal.modal("show");
			
			break;
		}

		case 'job_outfit': {
			let jobOutfitModal = $("#job-outfit-data-modal")
			jobOutfitModal.data("markerId", markerId);

			$("#job-outfit-outfits").empty();

			if(data.outfits) {
				(data.outfits).forEach(outfit => {
					createNewOutfit(outfit)
				})	
			}
			
			jobOutfitModal.modal("show");

			break;
		}

		case 'teleport': {
			let teleportModal = $("#teleport-data-modal");
			teleportModal.data("markerId", markerId);

			if(data.teleportCoords) {
				$("#teleport-x").val(data.teleportCoords.x);
				$("#teleport-y").val(data.teleportCoords.y);
				$("#teleport-z").val(data.teleportCoords.z);
			}

			teleportModal.modal("show");

			break;
		}

		case 'market': {
			let marketModal = $("#market-data-modal");
			marketModal.data("markerId", markerId);

			$("#market-modal-items-tbody").empty();

			if(data.items) {
				for (const [itemName, itemData] of Object.entries(data.items)) {
					addItemToMarket(itemName, itemData.price, itemData.blackMoney)
				}
			}

			marketModal.modal("show");

			break;
		}

		case 'harvest': {
			let harvestModal = $("#harvest-data-modal");
			harvestModal.data("markerId", markerId);

			$("#harvest-modal-items").empty();
			
			if(data.harvestableItems) {
				data.harvestableItems.forEach(item => {
					addItemToHarvestable(item.name, item.minQuantity, item.maxQuantity, item.time, item.chances);
				});
			}
			
			if(data.animations) {
				harvestModal.data("animations", data.animations)
			}

			if(data.itemTool) {
				$("#harvest-item-requires-tool").prop("checked", true);
				$("#harvest-item-tool-div").show();
				$("#harvest-item-tool").val(data.itemTool);
			} else {
				$("#harvest-item-requires-tool").prop("checked", false);
				$("#harvest-item-tool-div").hide();
			}

			if(data.itemToolLoseQuantity) {
				$("#harvest-item-tool-lose-on-use").prop("checked", true);
				$("#harvest-item-tool-lose-quantity").val(data.itemToolLoseQuantity);
				$("#harvest-item-lose-quantity-div").show();
			} else {
				$("#harvest-item-tool-lose-on-use").prop("checked", false);
				$("#harvest-item-lose-quantity-div").hide();
			}

			harvestModal.modal("show");

			break;
		}

		case 'process': {
			let processModal = $("#process-data-modal");
			processModal.data("markerId", markerId);
			
			if(data.itemToRemoveName)
				$("#item-to-remove-name").val(data.itemToRemoveName)

			if(data.itemToRemoveQuantity) 
				$("#item-to-remove-quantity").val(data.itemToRemoveQuantity)

			if(data.itemToAddName)
				$("#item-to-add-name").val(data.itemToAddName)

			if(data.itemToAddQuantity)
				$("#item-to-add-quantity").val(data.itemToAddQuantity)

			if(data.timeToProcess)
				$("#process-time").val(data.timeToProcess)

			if(data.animations)
				processModal.data("animations", data.animations)
			
			processModal.modal("show");
			break;
		}

		case 'weapon_upgrader': {
			let weaponUpgraderModal = $("#weapon-upgrader-data-modal");
			weaponUpgraderModal.data("markerId", markerId);

			if(data.componentsPrices) {
				for(const [componentName, componentPrice] of Object.entries(data.componentsPrices)) {
					$("#weapon-upgrader-components").find(`[data-componentname=${componentName}]`).val(componentPrice)
				}
			}

			if(data.tintsPrices) {
				for(const [tintId, tintPrice] of Object.entries(data.tintsPrices)) {
					$("#weapon-upgrader-tints").find(`[data-tintid=${tintId}]`).val(tintPrice)
				}
			}

			weaponUpgraderModal.modal("show");
			break;
		}

		case 'job_shop': {
			let jobShopModal = $("#job-shop-data-modal");
			jobShopModal.data("markerId", markerId);

			let allJobsSelect = $("#job-shop-all-jobs");
			
			allJobsSelect.find(".job-shop-job").remove();

			$.post(`https://${resName}/get-jobs-data`, JSON.stringify({}), function (jobs) {
				let jobsRanks = {}

				for(const [jobName, jobData] of Object.entries(jobs)) {
					if(jobData) {
						let jobDiv = $(`<option class="job-shop-job" value="${jobName}">${jobData.label}</option>`);
	
						jobsRanks[jobName] = jobData.ranks
						allJobsSelect.append(jobDiv);
					}
				}

				allJobsSelect.data("ranks", jobsRanks)
				jobShopModal.modal("show");
			}), "json";

			break;
		}

		case 'garage_owned': {
			let garageOwnedModal = $("#garage-owned-data-modal");
			garageOwnedModal.data("markerId", markerId);

			if(data.spawnCoords) {
				$("#garage-owned-spawnpoint-x").val(data.spawnCoords.x);
				$("#garage-owned-spawnpoint-y").val(data.spawnCoords.y);
				$("#garage-owned-spawnpoint-z").val(data.spawnCoords.z);
			}

			$("#garage-owned-heading").val(data.heading);

			garageOwnedModal.modal("show");
			break;
		}
	}
}

$("#garage-owned-current-coords").click(function() {
	$.post(`https://${resName}/get-current-coords`, {}, function (data) {
		var coords = data.coords;
		var heading = data.heading;

		if (coords) {
			$("#garage-owned-spawnpoint-x").val(coords.x)
			$("#garage-owned-spawnpoint-y").val(coords.y)
			$("#garage-owned-spawnpoint-z").val(coords.z)
		}

		if (heading) {
			$("#garage-owned-heading").val(heading)
		}
	})
});

$("#garage-owned-data-form").submit(function(event) {
	if (!this.checkValidity()) {
		event.stopPropagation();
		event.preventDefault();
		return;
	} else {
		$(this).removeClass(".was-validated");
	}

	let garageOwnedModal = $("#garage-owned-data-modal");

	let markerId = garageOwnedModal.data("markerId");
	let markerData = {
		spawnCoords: {
			x: parseFloat($("#garage-owned-spawnpoint-x").val()),
			y: parseFloat($("#garage-owned-spawnpoint-y").val()),
			z: parseFloat($("#garage-owned-spawnpoint-z").val()),
		},

		heading: parseFloat($("#garage-owned-heading").val())
	}

	$.post(`https://${resName}/update-marker-data`, JSON.stringify({ markerId: markerId, markerData: markerData}), function (data) {
		if (data.isSuccessful) {
			$(`#marker-row-id-${markerId}`).data("data", JSON.stringify(markerData))
		} else {
			showError(data.message)
		}
	});

	garageOwnedModal.modal("hide")
})

function getMarkerTypeOptionsLabel(markerType) {
	let noDataMarkers = {
		"wardrobe": true,
		"safe": true,
		"duty": true
	}

	let labels = {
		['crafting_table']: "Crafting recipes",
		['shop']: "Setup shop items",
		['garage']: "Setup temporary vehicles",
		['garage_buyable']: "Setup garage vehicles",
		['garage_owned']: "Setup garage",
		['boss']: "Boss options",
		['job_outfit']: "Manage outfits",
		['teleport']: "Setup teleports",
		['market']: "Setup sellable items",
		['harvest']: "Edit harvestable item",
		['process']: "Edit processable item",
		['weapon_upgrader']: "Edit components prices",
		['job_shop']: "Edit shop options",
	}

	if(noDataMarkers[markerType]) {
		return null;
	} else {
		return labels[markerType] || "Data"
	}
}

function editMarker(markerRow) {
	$("#edit-marker-form").removeClass("was-validated");
	let markerData = markerRow.data("marker-data");

	let isMarkerPublic = markerRow.data("is-public");
	
	let editMarkerModal = $("#edit-marker-dialog-modal");


	editMarkerModal.data("marker-id", markerData.id);
	editMarkerModal.data("marker-type", markerData.type);

	let markerDataLabel = getMarkerTypeOptionsLabel(markerData.type)
	
	let editMarkerOptionsBtn = $("#edit-marker-options")

	if(markerDataLabel) {
		editMarkerOptionsBtn.text(markerDataLabel);
		editMarkerOptionsBtn.show();
	} else {
		editMarkerOptionsBtn.hide();
	}

	if(markerData.blip && markerData.blip.spriteId) {
		$("#blip-data").show();
		$("#edit-marker-map-blip").prop("checked", true);
		$("#edit-marker-sprite-id").val(markerData.blip.spriteId);
		$("#edit-marker-blip-color").val(markerData.blip.color);
		$("#edit-marker-blip-scale").val(markerData.blip.scale);
	} else {
		$("#blip-data").hide();
		$("#edit-marker-map-blip").prop("checked", false);
	}

	if(markerData.ped && markerData.ped.model) {
		$("#edit-marker-npc").prop("checked", true);
		$("#edit-marker-npc-model").val(markerData.ped.model);
		$("#edit-marker-npc-heading").val(markerData.ped.heading);
		$("#edit-marker-npc-model-div").show();
	} else {
		$("#edit-marker-npc").prop("checked", false);
		$("#edit-marker-npc-model-div").hide();
	}

	$("#edit-marker-scale-x").val(markerData.scale.x);
	$("#edit-marker-scale-y").val(markerData.scale.y);
	$("#edit-marker-scale-z").val(markerData.scale.z);

	$("#edit-marker-type").val(markerData.markerType);

	$("#edit-marker-color").val(rgbToHex(markerData.color.r, markerData.color.g, markerData.color.b));
	$("#edit-marker-alpha").val(markerData.color.alpha);

	$("#edit-marker-label").val(markerData.label || "Default");
	$("#edit-marker-coord-x").val(markerData.coords.x);
	$("#edit-marker-coord-y").val(markerData.coords.y);
	$("#edit-marker-coord-z").val(markerData.coords.z);

	if(isMarkerPublic) {
		$("#edit-marker-min-grade-form").hide();
		$("#edit-marker-min-grade").val(0);
	} else {
		$("#edit-marker-min-grade-form").show();
		$("#edit-marker-min-grade").val(markerData.minGrade);
	}

	editMarkerModal.modal("show");
}

$("#edit-marker-map-blip").change(function(){
	let isEnabled = $(this).prop("checked");

	if(isEnabled) {
		$("#blip-data").show();
	} else {
		$("#blip-data").hide();
	}
})

$("#edit-marker-npc").change(function(){
	let isEnabled = $(this).prop("checked");

	if(isEnabled) {
		$("#edit-marker-npc-model-div").show();
	} else {
		$("#edit-marker-npc-model-div").hide();
	}
})

$("#edit-marker-current-coords-btn").click(function(){
	$.post(`https://${resName}/get-current-coords`, {}, function (data) {
		let coords = data.coords;

		if (coords) {
			$(`#edit-marker-coord-x`).val(coords.x)
			$(`#edit-marker-coord-y`).val(coords.y)
			$(`#edit-marker-coord-z`).val(coords.z)
		}
	})
})

$("#delete-marker-btn").click(function(){
	let editMarkerModal = $("#edit-marker-dialog-modal");
	let markerId = editMarkerModal.data("marker-id");

	editMarkerModal.modal("hide");

	if(markerId) {
		deleteDialog("Delete marker", "Are you sure you want to delete this marker?", function () {
			$.post(`https://${resName}/delete-marker`, JSON.stringify({ markerId: markerId }), function (data) {
				if (data.isSuccessful) {
					$(`#marker-row-id-${markerId}`).remove();
				} else {
					showError(data.message)
				}
			})
		})
	}
})

$("#edit-marker-form").submit(function(event){
	if (!this.checkValidity()) {
		event.stopPropagation();
		event.preventDefault();
		return;
	}

	let editMarkerModal = $("#edit-marker-dialog-modal");
	let markerId = editMarkerModal.data("marker-id");

	let labelDiv = $("#edit-marker-label");

	let markerTypeDiv = $("#edit-marker-type");

	let markerScaleXdiv = $("#edit-marker-scale-x");
	let markerScaleYdiv = $("#edit-marker-scale-y");
	let markerScaleZdiv = $("#edit-marker-scale-z");

	let markerColorDiv = $("#edit-marker-color");
	let markerAlphaDiv = $("#edit-marker-alpha");

	let xCoordDiv = $("#edit-marker-coord-x");
	let yCoordDiv = $("#edit-marker-coord-y");
	let zCoordDiv = $("#edit-marker-coord-z");
	let minGradeDiv = $("#edit-marker-min-grade");
	let blipSpriteDiv = $("#edit-marker-sprite-id");
	let blipColorDiv = $("#edit-marker-blip-color");
	let blipScaleDiv = $("#edit-marker-blip-scale");

	let enableMarkerBlip = $("#edit-marker-map-blip").prop("checked");

	if(enableMarkerBlip) {
		var blipSpriteId = 	parseInt(blipSpriteDiv.val());
		var blipColor = 	parseInt(blipColorDiv.val());
		var blipScale = 	parseFloat(blipScaleDiv.val());
	}

	let color = hexToRgb(markerColorDiv.val());

	let enableNPC = $("#edit-marker-npc").prop("checked");

	if(enableNPC) {
		var npcModel = $("#edit-marker-npc-model").val();
		var npcHeading = parseFloat($("#edit-marker-npc-heading").val());
	}

	let data = {
		markerId: markerId,

		label: labelDiv.val(),

		minGrade: parseInt(minGradeDiv.val()),

		coords: {
			x: parseFloat(xCoordDiv.val()),
			y: parseFloat(yCoordDiv.val()),
			z: parseFloat(zCoordDiv.val()),
		},

		blip: {
			spriteId: blipSpriteId,
			color: blipColor,
			scale: blipScale,
		},
		
		markerType: parseInt(markerTypeDiv.val()),

		scale: {
			x: parseFloat(markerScaleXdiv.val()),
			y: parseFloat(markerScaleYdiv.val()),
			z: parseFloat(markerScaleZdiv.val())
		},
		
		color: {
			r: color.r,
			g: color.g,
			b: color.b,
			alpha: parseInt(markerAlphaDiv.val())
		},

		ped: {
			model: npcModel,
			heading: npcHeading
		}
	}

	$.post(`https://${resName}/update-marker`, JSON.stringify(data), function (data) {
		if (data.isSuccessful) {
			editMarkerModal.modal("hide");

			var jobName = $("#job-markers").val();

			$.post(`https://${resName}/retrieve-job-markers`, JSON.stringify({ jobName: jobName }), function (markers) {
				markers = JSON.parse(markers)

				fillJobMarkers(markers)
			})
		} else {
			showError(data.message)
		}
	})
})

$("#edit-marker-current-heading-btn").click(function(){
	$.post(`https://${resName}/get-current-coords`, {}, function (data) {
		let heading = data.heading;

		if (heading) {
			$(`#edit-marker-npc-heading`).val(heading);
		}
	})
})

$("#edit-marker-options").click(function(){
	let editMarkerModal = $("#edit-marker-dialog-modal");

	let markerId = editMarkerModal.data("marker-id");
	let markerType = editMarkerModal.data("marker-type");

	editMarkerModal.modal("hide");

	openMarkerData(markerId, markerType);
})


function fillJobMarkers(markers) {
	let isThisPublicMarkers = $("#job-markers").val() == "public_marker";

	var isThereAnyMarker = Object.keys(markers).length > 0

	if (!isThereAnyMarker) {
		var mainRow = $(`
			<th scope="col">
				${isThisPublicMarkers ? "No public markers yet" : "This job doesn't have markers"}
			</th>
		`)
	} else {
		var mainRow = $(`
			<th class="fs-5" scope="col">ID</th>
			<th class="fs-5" scope="col">Label</th>
			<th class="fs-5" scope="col">Type</th>
			<th class="fs-5" scope="col">X</th>
			<th class="fs-5" scope="col">Y</th>
			<th class="fs-5" scope="col">Z</th>
			${isThisPublicMarkers ? null : `<th class="fs-5" scope="col">Min Grade</th>`}
		`)
	}

	$("#main-markers-row").empty().append(mainRow);
	$("#markers-content").empty();

	if (isThereAnyMarker) {
		for(const [k, markerData] of Object.entries(markers)) {		
			if(!markerData) continue;
			
			var row = $(`
				<tr id="marker-row-id-${markerData.id}" class="fs-5">
					<th scope="row">${markerData.id}</th>
					<td>${markerData.label || "Default"}</th>
					<td>${markerData.type}</td>
					<td>${markerData.coords.x}</td>
					<td>${markerData.coords.y}</td>
					<td>${markerData.coords.z}</td>
					${isThisPublicMarkers ? null : `<td>${markerData.minGrade}</td>`}
				</tr>
			`);

			row.data("marker-data", markerData)
			row.data("data", markerData.data)
			row.data("is-public", isThisPublicMarkers)

			row.click(function () {
				var markerRow = $(this)

				editMarker(markerRow);
			})

			$("#markers-content").append(row);
		}
	}
}

function openJobMarkers(jobName, jobLabel) {
	$("#job-creator").hide();

	$("#job-markers-label").text(`Markers - ${jobLabel}`)
	$("#job-markers").val(jobName);

	$.post(`https://${resName}/retrieve-job-markers`, JSON.stringify({ jobName: jobName }), function (markers) {
		markers = JSON.parse(markers)

		fillJobMarkers(markers)

		$("#job-markers").show();
	})
}

function createJobMarker(jobName) {
	inputDialog("Create marker", [
		{
			id: "markerType", label: "Marker Type:", type: "select", options: [
				{ value: "stash", label: "Stash" },
				{ value: "armory", label: "Armory" },
				{ value: "safe", label: "Safe" },
				{ value: "garage", label: "Garage - Temporary vehicles" },
				{ value: "garage_buyable", label: "Garage - Buyable vehicles" },
				{ value: "garage_owned", label: "Garage - Owned vehicles" },
				{ value: "boss", label: "Boss" },
				{ value: "wardrobe", label: "Wardrobe - Player saved outfits" },
				{ value: "job_outfit", label: "Job Outfit" },
				{ value: "shop", label: "Shop (buy items)" },
				{ value: "market", label: "Market (sell items)" },
				{ value: "harvest", label: "Harvest Point" },
				{ value: "process", label: "Process point" },
				{ value: "crafting_table", label: "Crafting Table" },
				{ value: "teleport", label: "Teleport point" },
				{ value: "weapon_upgrader", label: "Weapon Upgrader" },
				{ value: "duty", label: "On/Off Duty" },
			]
		},
		{ id: "label", label: "Label:", type: "text", default: "Default" },
		{ id: "markerCoordsX", label: "Coord X:", type: "number" },
		{ id: "markerCoordsY", label: "Coord Y:", type: "number" },
		{ id: "markerCoordsZ", label: "Coord Z:", type: "number" },
		{
			id: "currentCoordsBtn", label: "Current coords", type: "button", buttonType: "btn-success",
			buttonCallback: function (modal) {
				$.post(`https://${resName}/get-current-coords`, {}, function (data) {
					var coords = data.coords;

					if (coords) {
						$(`#modal-markerCoordsX`).val(coords.x)
						$(`#modal-markerCoordsY`).val(coords.y)
						$(`#modal-markerCoordsZ`).val(coords.z)
					}
				})
			}
		},
		{ id: "markerMinGrade", label: "Minimum Grade:", type: "number", default: 0 },
	], function (data) {
		data.jobName = jobName

		$.post(`https://${resName}/create-marker`, JSON.stringify(data), function (data) {
			if (data.isSuccessful) {
				$.post(`https://${resName}/retrieve-job-markers`, JSON.stringify({ jobName: jobName }), function (markers) {
					markers = JSON.parse(markers)

					fillJobMarkers(markers)

					let markerId = data.markerId;
					
					editMarker($(`#marker-row-id-${markerId}`))
				})
			} else {
				showError(data.message)
			}
		});
	})
}

function createPublicMarker() {
	inputDialog("Create public marker", [
		{
			id: "markerType", label: "Marker Type:", type: "select", options: [
				{ value: "stash", label: "Stash" },
				{ value: "armory", label: "Armory" },
				{ value: "safe", label: "Safe" },
				{ value: "garage", label: "Garage - Temporary vehicles" },
				{ value: "garage_buyable", label: "Garage - Buyable vehicles" },
				{ value: "garage_owned", label: "Garage - Owned vehicles" },
				{ value: "wardrobe", label: "Wardrobe - Player saved outfits" },
				{ value: "job_outfit", label: "Public Outfit" },
				{ value: "shop", label: "Shop (buy items)" },
				{ value: "market", label: "Market (sell items)" },
				{ value: "harvest", label: "Harvest Point" },
				{ value: "process", label: "Process Point" },
				{ value: "crafting_table", label: "Crafting Table" },
				{ value: "teleport", label: "Teleport point" },
				{ value: "weapon_upgrader", label: "Weapon Upgrader" },
				{ value: "job_shop", label: "Job Shop" },
			]
		},
		{ id: "label", label: "Label:", type: "text", default: "Default" },
		{ id: "markerCoordsX", label: "Coord X:", type: "number" },
		{ id: "markerCoordsY", label: "Coord Y:", type: "number" },
		{ id: "markerCoordsZ", label: "Coord Z:", type: "number" },
		{
			id: "currentCoordsBtn", label: "Current coords", type: "button", buttonType: "btn-success",
			buttonCallback: function (modal) {
				$.post(`https://${resName}/get-current-coords`, {}, function (data) {
					var coords = data.coords;

					if (coords) {
						$(`#modal-markerCoordsX`).val(coords.x)
						$(`#modal-markerCoordsY`).val(coords.y)
						$(`#modal-markerCoordsZ`).val(coords.z)
					}
				})
			}
		},
	], function (data) {
		$.post(`https://${resName}/create-public-marker`, JSON.stringify(data), function (data) {
			if (data.isSuccessful) {
				$.post(`https://${resName}/retrieve-job-markers`, JSON.stringify({ jobName: "public_marker" }), function (markers) {
					markers = JSON.parse(markers)

					fillJobMarkers(markers)

					let markerId = data.markerId;
					
					editMarker($(`#marker-row-id-${markerId}`))
				})
			} else {
				showError(data.message)
			}
		});
	})
}

$("#create-marker-btn").click(function () {
	var jobName = $("#job-markers").val();

	if(jobName == "public_marker") {
		createPublicMarker()
	} else {
		createJobMarker(jobName)
	}
});

$("#marker-data-add-vehicle").click(function () {
	var modelDiv = $("#marker-data-vehicle-model");
	var model = modelDiv.val();

	// Clears input
	modelDiv.val("");

	if (model) {
		modelDiv.removeClass("is-invalid");

		addVehicleToTemporaryGarage(model)
	} else {
		modelDiv.addClass("is-invalid");
	}
})

$("#markers-data-current-coords").hover(function(){
	$("#markers-data-current-coords").tooltip("show")
}, function(){
	$("#markers-data-current-coords").tooltip("hide")
})

$("#markers-data-current-coords").click(function () {
	$.post(`https://${resName}/get-current-coords`, {}, function (data) {
		var coords = data.coords;
		var heading = data.heading;

		if (coords) {
			$("#marker-data-spawnpoint-x").val(coords.x)
			$("#marker-data-spawnpoint-y").val(coords.y)
			$("#marker-data-spawnpoint-z").val(coords.z)
		}

		if (heading) {
			$("#marker-data-heading").val(heading)
		}
	})
})

$("#garage-data-modal-confirm").click(function () {
	let isEverythingValid = true;

	let coords = {};

	let xSpawnpointDiv = $("#marker-data-spawnpoint-x");
	let ySpawnpointDiv = $("#marker-data-spawnpoint-y");
	let zSpawnpointDiv = $("#marker-data-spawnpoint-z");

	let headingSpawnpointDiv = $("#marker-data-heading")

	let x = xSpawnpointDiv.val();
	let y = ySpawnpointDiv.val();
	let z = zSpawnpointDiv.val();

	let heading = headingSpawnpointDiv.val();

	if (x) {
		coords.x = x;

		xSpawnpointDiv.removeClass("is-invalid");
	} else {
		xSpawnpointDiv.addClass("is-invalid");
		isEverythingValid = false;
	}

	if (y) {
		coords.y = y;

		ySpawnpointDiv.removeClass("is-invalid");
	} else {
		ySpawnpointDiv.addClass("is-invalid");
		isEverythingValid = false;
	}

	if (z) {
		coords.z = z;

		zSpawnpointDiv.removeClass("is-invalid");
	} else {
		zSpawnpointDiv.addClass("is-invalid");
		isEverythingValid = false;
	}

	if (heading) {
		headingSpawnpointDiv.removeClass("is-invalid");
	} else {
		headingSpawnpointDiv.addClass("is-invalid");
		isEverythingValid = false;
	}

	if (isEverythingValid) {
		let vehicles = {};
		let vehiclesObject = $("#garage-data-model-tbody").children(".vehicle");
		let length = vehiclesObject.length;

		vehiclesObject.each(function (index, element) {
			let vehicleModel = $(element).find(".vehicle-model").text()
			let vehiclePrimaryColor = $(element).find(".vehicle-primary-color").val()
			let vehicleSecondaryColor = $(element).find(".vehicle-secondary-color").val()

			vehicles[vehicleModel] = {
				primaryColor: vehiclePrimaryColor,
				secondaryColor: vehicleSecondaryColor,
			}

			if (index === (length - 1)) {
				let markerId = $("#garage-data-modal").data("markerId")
				let markerData = { vehicles: vehicles, spawnCoords: coords, heading: heading }

				$.post(`https://${resName}/update-marker-data`, JSON.stringify({ markerId: markerId, markerData: markerData }), function (data) {
					$("#garage-data-modal").modal("hide");

					if (data.isSuccessful) {
						$(`#marker-row-id-${markerId}`).data("data", JSON.stringify(markerData))
					} else {
						showError(data.message)
					}
				})
			}
		})
	}
})

$("#boss-data-modal-confirm").click(function () {
	let canWashMoney = $("#boss-data-washmoney").prop('checked')
	let canWithdraw = $("#boss-data-withdraw").prop('checked')
	let canDeposit = $("#boss-data-deposit").prop('checked')
	let canEmployees = $("#boss-data-employees").prop('checked')
	let canGrades = $("#boss-data-grades").prop('checked')

	if(canWashMoney) {
		var washMoneyReturnPercentage = parseInt($("#boss-data-washmoney-percentage").val());
		var washMoneyGoesToSocietyAccount = $("#boss-data-washmoney-to-society-account").prop("checked");
	}

	let markerId = $("#boss-data-modal").data("markerId")
	let markerData = {
		canWashMoney: canWashMoney,
		washMoneyReturnPercentage: washMoneyReturnPercentage,
		washMoneyGoesToSocietyAccount: washMoneyGoesToSocietyAccount,
		canWithdraw: canWithdraw,
		canDeposit: canDeposit,
		canEmployees: canEmployees,
		canGrades: canGrades,
	}

	$.post(`https://${resName}/update-marker-data`, JSON.stringify({ markerId: markerId, markerData: markerData }), function (data) {
		$("#boss-data-modal").modal("hide");

		if (data.isSuccessful) {
			$(`#marker-row-id-${markerId}`).data("data", JSON.stringify(markerData))
		} else {
			showError(data.message)
		}
	})
})

$("#boss-data-washmoney").change(function() {
	if($(this).prop("checked")) {
		$("#boss-data-washmoney-data").show();
	} else {
		$("#boss-data-washmoney-data").hide();
	}
})

function addItemToShop(itemName, itemData) {
	var newItem = $(`
		<tr class="border">
			<td class="col">
				<p class="text-center">${itemName}</p>
			</td>
			
			<td class="col">
				<p class="text-center">$${itemData.price}</p>
			</td>

			<td class="col">
				<div class="form-check form-switch col-md-4 offset-md-4">
					<input class="form-check-input item-blackmoney" type="checkbox"}>
				</div>
			</td>
			
			<td class="col">
				<button type="button" class="btn btn-outline-danger col-12">Remove</button>
			</td>
		</tr>
	`)

	newItem.data("item-name", itemName);
	newItem.data("item-price", parseInt(itemData.price));

	newItem.find(".item-blackmoney").prop("checked", itemData.blackMoney);

	newItem.find(".btn").click(function () {
		newItem.remove();
	})

	$('#shop-data-items-container').append(newItem)
}

$("#shop-data-add-btn").click(function () {
	var isEverythingValid = true

	var itemNameDiv = $("#shop-data-item-id")
	var itemPriceDiv = $("#shop-data-item-price")
	var itemName = itemNameDiv.val();
	var itemPrice = itemPriceDiv.val();

	let itemData = {
		price: itemPrice
	}

	if (!itemName) {
		itemNameDiv.addClass("is-invalid")
		isEverythingValid = false
	} else {
		itemNameDiv.removeClass("is-invalid")
	}

	if (!itemPrice) {
		itemPriceDiv.addClass("is-invalid")
		isEverythingValid = false
	} else {
		itemPriceDiv.removeClass("is-invalid")
	}

	if (isEverythingValid) {
		addItemToShop(itemName, itemData)
	}
})

$("#shop-data-modal-confirm").click(function () {
	var markerId = $("#shop-data-modal").data("markerId")

	var itemsOnSale = {};

	var itemsContainer = $("#shop-data-items-container")

	var itemsNumber = itemsContainer.children().length

	if (itemsNumber == 0) {
		let markerData = {
			itemsOnSale: {}
		}
		$.post(`https://${resName}/update-marker-data`, JSON.stringify({ markerId: markerId, markerData: markerData}), function (data) {
			if (data.isSuccessful) {
				$(`#marker-row-id-${markerId}`).data("data", JSON.stringify(markerData))
			} else {
				showError(data.message)
			}
		});
		$("#shop-data-modal").modal("hide")
	} else {
		itemsContainer.children().each(function (index, element) {
			let itemName = $(element).data("item-name");
			let itemPrice = $(element).data("item-price");
			let blackMoney = $(element).find(".item-blackmoney").prop("checked");

			if (itemName && itemPrice) {
				itemsOnSale[itemName] = {
					price: itemPrice,
					blackMoney: blackMoney
				};
			}

			if (index == itemsNumber - 1) {
				let markerData = {
					itemsOnSale: itemsOnSale
				} 

				$.post(`https://${resName}/update-marker-data`, JSON.stringify({ markerId: markerId, markerData: markerData}), function (data) {
					if (data.isSuccessful) {
						$(`#marker-row-id-${markerId}`).data("data", JSON.stringify(markerData))
					} else {
						showError(data.message)
					}
				});
				$("#shop-data-modal").modal("hide")
			}
		})
	}
})


$("#garage-buyable-add-vehicle").click(function () {
	var isEverythingValid = true;
	
	var modelDiv = $("#garage-buyable-vehicle-model");
	var model = modelDiv.val();
	var priceDiv = $("#garage-buyable-vehicle-price");
	var price = parseInt(priceDiv.val());

	// Clears input
	modelDiv.val("");
	priceDiv.val("");

	if (model) {
		modelDiv.removeClass("is-invalid");
	} else {
		modelDiv.addClass("is-invalid");
		isEverythingValid = false
	}

	if(price) {
		priceDiv.removeClass("is-invalid")
	} else {
		priceDiv.addClass("is-invalid")
		isEverythingValid = false
	}

	if(isEverythingValid) {
		var vehicleInputGroup = $(`<div class="input-group mt-1 vehicle"></div>`)

		var vehicleInput = $(`<input type="text" class="form-control vehicle-model" placeholder="Vehicle model" disabled value="${model}">`);
		var moneySpan = $(`<span class="input-group-text">$</span>`)
		var vehiclePrice = $(`<input type="text" class="form-control vehicle-price" placeholder="Vehicle price" disabled value="${price}">`);
		var deleteVehicle = $(`<button class="btn btn-outline-danger" type="button">Delete</button>`);

		vehicleInputGroup.append(vehicleInput, moneySpan, vehiclePrice, deleteVehicle);

		$(deleteVehicle).click(function () {
			$(this).parent().remove();
		})

		$("#garage-buyable-vehicles").append(vehicleInputGroup)
	}
})

$("#garage-buyable-modal-confirm").click(function(){
	var isEverythingValid = true;

	var coords = {};

	var x = parseFloat($("#garage-buyable-spawnpoint-x").val());
	var y = parseFloat($("#garage-buyable-spawnpoint-y").val());
	var z = parseFloat($("#garage-buyable-spawnpoint-z").val());

	var heading = parseFloat($("#garage-buyable-heading").val());

	if (x) {
		coords.x = x;
		$("#garage-buyable-spawnpoint-x").removeClass("is-invalid");
	} else {
		$("#garage-buyable-spawnpoint-x").addClass("is-invalid");
		isEverythingValid = false;
	}

	if (y) {
		coords.y = y;
		$("#garage-buyable-spawnpoint-y").removeClass("is-invalid");
	} else {
		$("#garage-buyable-spawnpoint-y").addClass("is-invalid");
		isEverythingValid = false;
	}

	if (z) {
		coords.z = z;
		$("#garage-buyable-spawnpoint-z").removeClass("is-invalid");
	} else {
		$("#garage-buyable-spawnpoint-z").addClass("is-invalid");
		isEverythingValid = false;
	}

	if (!heading) {
		$("#garage-buyable-heading").addClass("is-invalid");
	} else {
		$("#garage-buyable-heading").removeClass("is-invalid");
	}

	if (isEverythingValid) {
		var vehicles = {};
		var vehiclesObject = $("#garage-buyable-vehicles").find(".vehicle");
		var length = vehiclesObject.length;

		var markerId = $("#garage-buyable-data-modal").data("markerId")
		var markerData = {spawnCoords: coords, heading: heading }

		if(length > 0) {
			vehiclesObject.each(function (index, element) {
				var model = $(element).find(".vehicle-model").val();
				var price = parseInt($(element).find(".vehicle-price").val());
	
				vehicles[model] = price
	
				if (index === (length - 1)) {
					markerData.vehicles = vehicles
					
					$.post(`https://${resName}/update-marker-data`, JSON.stringify({ markerId: markerId, markerData: markerData }), function (data) {
						$("#garage-buyable-data-modal").modal("hide");
	
						if (data.isSuccessful) {
							$(`#marker-row-id-${markerId}`).data("data", JSON.stringify(markerData))
						} else {
							showError(data.message)
						}
					})
				}
			})
		} else {
			markerData.vehicles = {};
			$.post(`https://${resName}/update-marker-data`, JSON.stringify({ markerId: markerId, markerData: markerData }), function (data) {
				$("#garage-buyable-data-modal").modal("hide");

				if (data.isSuccessful) {
					$(`#marker-row-id-${markerId}`).data("data", JSON.stringify(markerData))
				} else {
					showError(data.message)
				}
			})
		}
	}
})

$("#garage-buyable-current-coords").click(function() {
	$.post(`https://${resName}/get-current-coords`, {}, function (data) {
		var coords = data.coords;
		var heading = data.heading;

		if (coords) {
			$("#garage-buyable-spawnpoint-x").val(coords.x)
			$("#garage-buyable-spawnpoint-y").val(coords.y)
			$("#garage-buyable-spawnpoint-z").val(coords.z)
		}

		if (heading) {
			$("#garage-buyable-heading").val(heading)
		}
	})
})

function addNewCraftableToCraftables(resultItemName, craftingData) {
	var craftablesDiv = $("#craftables")

	var newCraftable = $(`
		<div class="container border mt-3">

			<div class="input-group mb-3 mt-2">
				<span class="input-group-text">Time to craft</span>
				<input type="number" class="form-control result-item-crafting-time" placeholder="Seconds" value="${craftingData && craftingData.craftingTime || 8}">
			</div>

			<div class="input-group my-2">
				<span class="input-group-text">Result item</span>
				<input type="text" class="form-control result-item" placeholder="Item/Weapon id" value=${resultItemName || ""}>
				<span class="input-group-text">Quantity</span>
				<input type="text" class="form-control result-item-quantity" placeholder="Item quantity" value=${craftingData && craftingData.quantity || 1}>
			</div>

			<table class="table">
				<thead>
					<tr>
						<th scope="col">Item Id</th>
						<th scope="col">Item Quantity</th>
						<th scope="col">Lose on use</th>
						<th scope="col">Remove</th>
					</tr>
				</thead>
				<tbody class="craft-ingredients">

				</tbody>
			</table>

			<div class="input-group mb-2">
				<span class="input-group-text">Item id</span>
				<input type="text" class="form-control crafting-table-item-id">
				<span class="input-group-text">Quantity</span>
				<input type="number" class="form-control crafting-table-item-quantity">
				<button type="button" class="btn btn-success ms-2 add-to-craft-btn">Add to craft</button>
			</div>

			<button type="button" class="btn btn-danger mt-5 mb-2 remove-craft-btn">Remove craft</button>
			<button type="button" class="btn btn-secondary mt-5 mb-2 animations-craft-btn float-end">Animations</button>
		</div>
	`)

	newCraftable.find(".remove-craft-btn").click(function() {
		newCraftable.remove();
	})

	newCraftable.find(".animations-craft-btn").click(function() {
		inputAnimations(newCraftable.data("animations"), function(animations) {
			newCraftable.data("animations", animations)
		});
	})

	var addToCraftBtn = newCraftable.find(".add-to-craft-btn")
	addToCraftBtn.click(function() {
		var itemIdDiv = newCraftable.find(".crafting-table-item-id");
		var itemQuantityDiv = newCraftable.find(".crafting-table-item-quantity");

		var itemName = itemIdDiv.val();
		var itemQuantity = parseInt(itemQuantityDiv.val());

		var isEverythingValid = true

		if(itemName) {
			itemIdDiv.removeClass("is-invalid");
		} else {
			itemIdDiv.addClass("is-invalid");
			isEverythingValid = false;
		}

		if(itemQuantity && itemQuantity > 0) {
			itemQuantityDiv.removeClass("is-invalid");
		} else {
			itemQuantityDiv.addClass("is-invalid");
			isEverythingValid = false;
		}

		if(isEverythingValid) {
			var craftIngredientsDiv = newCraftable.find(".craft-ingredients");

			let newCraftItem = $(`
				<tr data-item-name=${itemName} data-item-quantity=${itemQuantity}>
					<th scope="row">${itemName}</td>
					<td>${itemQuantity}</td>
					<td>
						<div class="form-check form-switch fs-4">
							<input class="form-check-input lose-on-use-checkbox" type="checkbox" checked>
						</div>
					</td>
					<td><button type="button" class="btn btn-outline-warning remove-ingredient-btn">Remove</button></td>
				</tr>
			`)

			newCraftItem.find('.remove-ingredient-btn').click(function() {
				newCraftItem.remove()
			})

			craftIngredientsDiv.append(newCraftItem)

			itemIdDiv.val("");
			itemQuantityDiv.val("");
		}
	})

	if(craftingData && craftingData.recipes) {
		let craftIngredientsDiv = newCraftable.find('.craft-ingredients');
		
		for (const [ingredientName, ingredientData] of Object.entries(craftingData.recipes)) {
			let newCraftItem = $(`
				<tr data-item-name=${ingredientName} data-item-quantity=${ingredientData.quantity}>
					<th scope="row">${ingredientName}</td>
					<td>${ingredientData.quantity}</td>
					<td>
						<div class="form-check form-switch fs-4">
							<input class="form-check-input lose-on-use-checkbox" type="checkbox">
						</div>
					</td>
					<td><button type="button" class="btn btn-outline-warning remove-ingredient-btn">Remove</button></td>
				</tr>
			`)

			let loseOnUse = ingredientData.loseOnUse
			newCraftItem.find(".lose-on-use-checkbox").prop("checked", loseOnUse)

			newCraftItem.find('.remove-ingredient-btn').click(function() {
				newCraftItem.remove()
			})

			craftIngredientsDiv.append(newCraftItem)
		}
	}

	if(craftingData && craftingData.animations) {
		newCraftable.data("animations", craftingData.animations)
	}

	craftablesDiv.append(newCraftable);
}

$("#crafting-table-new-craft-btn").click(function() {
	addNewCraftableToCraftables()
})

$("#crafting-table-modal-confirm").click(function() {
	var markerId = $("#crafting-table-data-modal").data("markerId");
	var markerData = {};

	var craftablesItems = {};

	var craftables = $("#craftables").children();

	var length = craftables.length;

	var isEverythingValid = true

	craftables.each(function(craftableIndex, craftableElement) {
		var craftable = $(craftableElement);

		var resultItemDiv = craftable.find('.result-item');
		var resultItemName = resultItemDiv.val();

		let resultItemQuantityDiv = craftable.find('.result-item-quantity');
		let resultItemQuantity = parseInt(resultItemQuantityDiv.val());

		let resultItemCraftingTimeDiv = craftable.find('.result-item-crafting-time');
		let resultItemCraftingTime = parseInt(resultItemCraftingTimeDiv.val());

		if(resultItemName) {
			resultItemDiv.removeClass("is-invalid");
		} else {
			resultItemDiv.addClass("is-invalid");
			isEverythingValid = false;
		}

		if(resultItemQuantity) {
			resultItemQuantityDiv.removeClass("is-invalid");
		} else {
			resultItemQuantityDiv.addClass("is-invalid");
			isEverythingValid = false;
		}

		if(resultItemCraftingTime) {
			resultItemCraftingTimeDiv.removeClass("is-invalid");
		} else {
			resultItemCraftingTimeDiv.addClass("is-invalid");
			isEverythingValid = false;
		}

		craftablesItems[resultItemName] = {
			recipes: {},
			animations: craftable.data("animations"),
			quantity: resultItemQuantity || 1,
			craftingTime: resultItemCraftingTime || 8
		}

		var ingredientsItemsDiv = craftable.find('.craft-ingredients').children();

		var ingredientsLength = ingredientsItemsDiv.length
		
		if(ingredientsLength > 0) {
			
			craftable.find('.crafting-table-item-id').removeClass("is-invalid");
			craftable.find('.crafting-table-item-quantity').removeClass("is-invalid");

			ingredientsItemsDiv.each(function(ingredientIndex, ingredientElement){
				var ingredientDiv = $(ingredientElement)
	
				var ingredientName = ingredientDiv.data("item-name");
				var ingredientQuantity = ingredientDiv.data("item-quantity");
				var loseOnUse = ingredientDiv.find(".lose-on-use-checkbox").prop("checked")
				
				craftablesItems[resultItemName].recipes[ingredientName] = {
					quantity: ingredientQuantity,
					loseOnUse: loseOnUse
				}
	
				if(ingredientIndex === ingredientsLength - 1) {
					if(craftableIndex === length-1) {
						markerData.craftablesItems = craftablesItems;
	
						if(isEverythingValid) {
							$.post(`https://${resName}/update-marker-data`, JSON.stringify({ markerId: markerId, markerData: markerData }), function (data) {
								$("#crafting-table-data-modal").modal("hide");
				
								if (data.isSuccessful) {
									$(`#marker-row-id-${markerId}`).data("data", JSON.stringify(markerData))
								} else {
									showError(data.message)
								}
							})
						}
					}
				}
			})
		} else {
			craftable.find('.crafting-table-item-id').addClass("is-invalid");
			craftable.find('.crafting-table-item-quantity').addClass("is-invalid");
		}
	})
})

$("#armory-modal-confirm").click(function(){
	let markerId = $("#armory-data-modal").data("markerId")

	let markerData = {
		isShared: $("#armory-is-shared").prop("checked"),
		refillOnTake: $("#armory-refill-on-take").prop("checked")
	}

	$.post(`https://${resName}/update-marker-data`, JSON.stringify({ markerId: markerId, markerData: markerData }), function (data) {
		$("#armory-data-modal").modal("hide");

		if (data.isSuccessful) {
			$(`#marker-row-id-${markerId}`).data("data", JSON.stringify(markerData))
		} else {
			showError(data.message)
		}
	})
})

$("#delete-armory-content").click(function(){
	let armoryModal = $("#armory-data-modal");
	
	let markerId = armoryModal.data("markerId")
	
	armoryModal.modal("hide");

	deleteDialog("Armory inventory", "Do you want to delete this armory's content?", function () {
		$.post(`https://${resName}/delete-armory-inventory`, JSON.stringify({ markerId: markerId }), function (data) {
			if(!data.isSuccessful) {
				showError(data.message)
			}
		})
	})
})

function createNewOutfit(outfit){
	outfit = outfit || {};

	outfit.tshirt_1 = outfit.tshirt_1 || 0;
	outfit.tshirt_2 = outfit.tshirt_2 || 0;

	outfit.torso_1 = outfit.torso_1 || 0;
	outfit.torso_2 = outfit.torso_2 || 0;

	outfit.decals_1 = outfit.decals_1 || 0;
	outfit.decals_2 = outfit.decals_2 || 0;

	outfit.arms = outfit.arms || 0;
	outfit.arms_2 = outfit.arms_2 || 0;

	outfit.pants_1 = outfit.pants_1 || 0;
	outfit.pants_2 = outfit.pants_2 || 0;

	outfit.shoes_1 = outfit.shoes_1 || 0;
	outfit.shoes_2 = outfit.shoes_2 || 0;

	outfit.mask_1 = outfit.mask_1 || 0;
	outfit.mask_2 = outfit.mask_2 || 0;

	outfit.bproof_1 = outfit.bproof_1 || 0;
	outfit.bproof_2 = outfit.bproof_2 || 0;

	outfit.chain_1 = outfit.chain_1 || 0;
	outfit.chain_2 = outfit.chain_2 || 0;

	outfit.helmet_1 = outfit.helmet_1 || -1;
	outfit.helmet_2 = outfit.helmet_2 || 0;

	outfit.glasses_1 = outfit.glasses_1 || 0;
	outfit.glasses_2 = outfit.glasses_2 || 0;

	outfit.bags_1 = outfit.bags_1 || 0;
	outfit.bags_2 = outfit.bags_2 || 0;

	let outfitsDiv = $("#job-outfit-outfits")
	let outfitId = $("#job-outfit-outfits").children().length + 1;
	
	let outfitDiv = $(`
		<div class="accordion accordion-flush mt-1" id="job-outfit-id-${outfitId}" data-label="${outfit.label}">
			<div class="accordion-item">
				<h2 class="accordion-header">
					<button class="accordion-button collapsed" type="button" data-bs-toggle="collapse"
						data-bs-target="#job-outfit-content-id-${outfitId}" aria-expanded="false">
						${outfit.label}
					</button>
				</h2>
				<div id="job-outfit-content-id-${outfitId}" class="accordion-collapse collapse" data-bs-parent="#job-outfit-id-${outfitId}">
					<div class="accordion-body container">
						<div class="outfit">
							<div class="input-group mb-3 col">
								<span class="input-group-text col">T-Shirt</span>
								<input type="number" class="form-control float-end col outfit-tshirt" value=${outfit.tshirt_1}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-tshirt-color" value=${outfit.tshirt_2}>
							</div>
							<div class="input-group mb-3 col">
								<span class="input-group-text col">Torso</span>
								<input type="number" class="form-control float-end col outfit-torso" value=${outfit.torso_1}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-torso-color" value=${outfit.torso_2}>
							</div>
							<div class="input-group mb-3 col">
								<span class="input-group-text col">Decals</span>
								<input type="number" class="form-control float-end col outfit-decals" value=${outfit.decals_1}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-decals-color" value=${outfit.decals_2}>
							</div>
							<div class="input-group mb-3 col">
								<span class="input-group-text col">Arms</span>
								<input type="number" class="form-control float-end col outfit-arms" value=${outfit.arms}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-arms-color" value=${outfit.arms_2}>
							</div>
							<div class="input-group mb-3 col">
								<span class="input-group-text col">Pants</span>
								<input type="number" class="form-control float-end col outfit-pants" value=${outfit.pants_1}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-pants-color" value=${outfit.pants_2}>
							</div>
							<div class="input-group mb-3 col">
								<span class="input-group-text col">Shoes</span>
								<input type="number" class="form-control float-end col outfit-shoes" value=${outfit.shoes_1}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-shoes-color" value=${outfit.shoes_2}>
							</div>
							<div class="input-group mb-3 col">
								<span class="input-group-text col">Mask</span>
								<input type="number" class="form-control float-end col outfit-mask" value=${outfit.mask_1}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-mask-color" value=${outfit.mask_2}>
							</div>
							<div class="input-group mb-3 col">
								<span class="input-group-text col">Bulletproof</span>
								<input type="number" class="form-control float-end col outfit-bulletproof" value=${outfit.bproof_1}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-bulletproof-color" value=${outfit.bproof_2}>
							</div>
							<div class="input-group mb-3 col">
								<span class="input-group-text col">Chain</span>
								<input type="number" class="form-control float-end col outfit-chain" value=${outfit.chain_1}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-chain-color" value=${outfit.chain_2}>
							</div>
							<div class="input-group mb-3 col">
								<span class="input-group-text col">Helmet/Hat</span>
								<input type="number" class="form-control float-end col outfit-helmet" value=${outfit.helmet_1}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-helmet-color" value=${outfit.helmet_2}>
							</div>
							<div class="input-group mb-3 col">
								<span class="input-group-text col">Glasses</span>
								<input type="number" class="form-control float-end col outfit-glasses" value=${outfit.glasses_1}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-glasses-color" value=${outfit.glasses_2}>
							</div>
							<div class="input-group mb-3 col">
								<span class="input-group-text col">Bag</span>
								<input type="number" class="form-control float-end col outfit-bag" value=${outfit.bags_1}>
								<span class="input-group-text col">Color</span>
								<input type="number" class="form-control float-end col outfit-bag-color" value=${outfit.bags_2}>
							</div>
						</div>

						<button type="button" class="btn btn-success mt-1 current-outfit-btn">Current outfit</button>

						<button type="button" class="btn btn-danger mt-1 delete-outfit-btn">Delete outfit</button>
					</div>
				</div>
			</div>
		</div>
	`)

	outfitDiv.find(".current-outfit-btn").click(function(){
		$.post(`https://${resName}/get-current-outfit`, JSON.stringify({}), function (data) {
			outfitDiv.find(".outfit-tshirt").val(data.tshirt_1)
			outfitDiv.find(".outfit-tshirt-color").val(data.tshirt_2)

			outfitDiv.find(".outfit-torso").val(data.torso_1)
			outfitDiv.find(".outfit-torso-color").val(data.torso_2)

			outfitDiv.find(".outfit-decals").val(data.decals_1)
			outfitDiv.find(".outfit-decals-color").val(data.decals_2)

			outfitDiv.find(".outfit-arms").val(data.arms)
			outfitDiv.find(".outfit-arms-color").val(data.arms_2)

			outfitDiv.find(".outfit-pants").val(data.pants_1)
			outfitDiv.find(".outfit-pants-color").val(data.pants_2)

			outfitDiv.find(".outfit-shoes").val(data.shoes_1)
			outfitDiv.find(".outfit-shoes-color").val(data.shoes_2)

			outfitDiv.find(".outfit-mask").val(data.mask_1)
			outfitDiv.find(".outfit-mask-color").val(data.mask_2)

			outfitDiv.find(".outfit-bulletproof").val(data.bproof_1)
			outfitDiv.find(".outfit-bulletproof-color").val(data.bproof_2)

			outfitDiv.find(".outfit-chain").val(data.chain_1)
			outfitDiv.find(".outfit-chain-color").val(data.chain_2)

			outfitDiv.find(".outfit-helmet").val(data.helmet_1)
			outfitDiv.find(".outfit-helmet-color").val(data.helmet_2)

			outfitDiv.find(".outfit-glasses").val(data.glasses_1)
			outfitDiv.find(".outfit-glasses-color").val(data.glasses_2)

			outfitDiv.find(".outfit-bag").val(data.bags_1)
			outfitDiv.find(".outfit-bag-color").val(data.bags_2)
		});
	})

	outfitDiv.find(".delete-outfit-btn").click(function(){
		deleteDialog("Delete Outfit", "Are you sure to delete this outfit?", function(){
			outfitDiv.remove();
		})
	})

	$(outfitsDiv).append(outfitDiv)
}

function getOutfitFromOutfitDiv(outfitDiv) {
	let outfit = {}

	outfit.label = outfitDiv.data("label")

	outfit.tshirt_1 = parseInt(outfitDiv.find(".outfit-tshirt").val()) || 0;
	outfit.tshirt_2 = parseInt(outfitDiv.find(".outfit-tshirt-color").val()) || 0;

	outfit.torso_1 = parseInt(outfitDiv.find(".outfit-torso").val()) || 0;
	outfit.torso_2 = parseInt(outfitDiv.find(".outfit-torso-color").val()) || 0;

	outfit.decals_1 = parseInt(outfitDiv.find(".outfit-decals").val()) || 0;
	outfit.decals_2 = parseInt(outfitDiv.find(".outfit-decals-color").val()) || 0;

	outfit.arms = parseInt(outfitDiv.find(".outfit-arms").val()) || 0;
	outfit.arms_2 = parseInt(outfitDiv.find(".outfit-arms-color").val()) || 0;

	outfit.pants_1 = parseInt(outfitDiv.find(".outfit-pants").val()) || 0;
	outfit.pants_2 = parseInt(outfitDiv.find(".outfit-pants-color").val()) || 0;

	outfit.shoes_1 = parseInt(outfitDiv.find(".outfit-shoes").val()) || 0;
	outfit.shoes_2 = parseInt(outfitDiv.find(".outfit-shoes-color").val()) || 0;

	outfit.mask_1 = parseInt(outfitDiv.find(".outfit-mask").val()) || 0;
	outfit.mask_2 = parseInt(outfitDiv.find(".outfit-mask-color").val()) || 0;

	outfit.bproof_1 = parseInt(outfitDiv.find(".outfit-bulletproof").val()) || 0;
	outfit.bproof_2 = parseInt(outfitDiv.find(".outfit-bulletproof-color").val()) || 0;

	outfit.chain_1 = parseInt(outfitDiv.find(".outfit-chain").val()) || 0;
	outfit.chain_2 = parseInt(outfitDiv.find(".outfit-chain-color").val()) || 0;

	outfit.helmet_1 = parseInt(outfitDiv.find(".outfit-helmet").val()) || -1;
	outfit.helmet_2 = parseInt(outfitDiv.find(".outfit-helmet-color").val()) || 0

	outfit.glasses_1 = parseInt(outfitDiv.find(".outfit-glasses").val()) || 0;
	outfit.glasses_2 = parseInt(outfitDiv.find(".outfit-glasses-color").val()) || 0;

	outfit.bags_1 = parseInt(outfitDiv.find(".outfit-bag").val()) || 0;
	outfit.bags_2 = parseInt(outfitDiv.find(".outfit-bag-color").val()) || 0;

	return outfit;
}

$("#job-outfit-modal-confirm").click(function(){
	let jobOutfitsModal = $("#job-outfit-data-modal");
	let jobOutfitsDiv = $("#job-outfit-outfits");

	let outfitsDiv = jobOutfitsDiv.children()
	let outfitLength = outfitsDiv.length;

	var markerId = jobOutfitsModal.data("markerId")

	if(outfitLength > 0) {
		let outfits = [];

		outfitsDiv.each(function(index, outfitDivRaw){
			let outfitDiv = $(outfitDivRaw);

			let outfit = getOutfitFromOutfitDiv(outfitDiv);

			outfits.push(outfit);

			if(index == outfitLength-1) {
				let markerData = {outfits: outfits}

				$.post(`https://${resName}/update-marker-data`, JSON.stringify({ markerId: markerId, markerData: markerData }), function (data) {
					jobOutfitsModal.modal("hide");

					if (data.isSuccessful) {
						$(`#marker-row-id-${markerId}`).data("data", JSON.stringify(markerData))
					} else {
						showError(data.message)
					}
				})
			}
		})
	} else {
		$.post(`https://${resName}/update-marker-data`, JSON.stringify({ markerId: markerId, markerData: {outfits: []} }), function (data) {
			jobOutfitsModal.modal("hide");

			if (data.isSuccessful) {
				$(`#marker-row-id-${markerId}`).data("data", JSON.stringify(markerData))
			} else {
				showError(data.message)
			}
		})
	}	
})

$("#job-outfit-new-outfit-btn").click(function(){
	inputDialog("Create new outfit", [
		{ id: "outfitLabel", label: "New outfit label:" },
	], function (data) {
		let outfit = {label: data.outfitLabel}
		createNewOutfit(outfit);
	});
})

$("#teleport-current-coords-btn").click(function(){
	$.post(`https://${resName}/get-current-coords`, {}, function (data) {
		var coords = data.coords;

		if (coords) {
			$(`#teleport-x`).val(coords.x)
			$(`#teleport-y`).val(coords.y)
			$(`#teleport-z`).val(coords.z)
		}
	})
});

$("#teleport-modal-confirm").click(function(){
	let isEverythingValid = true
	
	let teleportModal = $("#teleport-data-modal");

	let markerId = teleportModal.data("markerId");

	let xTeleportDiv = $(`#teleport-x`);
	let yTeleportDiv = $(`#teleport-y`);
	let zTeleportDiv = $(`#teleport-z`);

	let coordX = parseFloat(xTeleportDiv.val())
	let coordY = parseFloat(yTeleportDiv.val())
	let coordZ = parseFloat(zTeleportDiv.val())

	if(coordX) {
		xTeleportDiv.removeClass("is-invalid");
	} else {
		xTeleportDiv.addClass("is-invalid");
		isEverythingValid = false
	}

	if(coordY) {
		yTeleportDiv.removeClass("is-invalid");
	} else {
		yTeleportDiv.addClass("is-invalid");
		isEverythingValid = false
	}

	if(coordZ) {
		zTeleportDiv.removeClass("is-invalid");
	} else {
		zTeleportDiv.addClass("is-invalid");
		isEverythingValid = false
	}

	if(isEverythingValid) {
		let markerData = {
			teleportCoords: {
				x: coordX,
				y: coordY,
				z: coordZ,
			}
		}

		$.post(`https://${resName}/update-marker-data`, JSON.stringify({ markerId: markerId, markerData: markerData }), function (data) {
			teleportModal.modal("hide");

			if (data.isSuccessful) {
				$(`#marker-row-id-${markerId}`).data("data", JSON.stringify(markerData))
			} else {
				showError(data.message)
			}
		})
	}
})

function addItemToMarket(itemName, itemPrice, blackMoney) {
	let itemsTableDiv = $("#market-modal-items-tbody");

	let itemDiv = $(`
		<tr class="item">
			<th class="item-name">${itemName}</th>
			
			<td class="item-price">${itemPrice}</td>

			<td>
				<div class="form-check form-switch">
					<input class="form-check-input item-blackmoney" type="checkbox"}>
				</div>
			</td>

			<td class="delete-btn"></td>
		</tr>
	`)

	let deleteBtn = $(`<button type="button" class="btn btn-outline-danger">Remove</button>`);

	deleteBtn.click(function(){
		itemDiv.remove();
	})

	itemDiv.find(".delete-btn").append(deleteBtn);
	
	itemDiv.find(".item-blackmoney").prop("checked", blackMoney);

	itemsTableDiv.append(itemDiv);
}

$("#market-modal-new-item-btn").click(function(){
	let itemIdDiv = $("#market-modal-new-item-name-input");
	let itemId = itemIdDiv.val();

	let itemPriceDiv = $("#market-modal-new-item-price-input");
	let itemPrice = itemPriceDiv.val();

	if(itemId) {
		itemIdDiv.removeClass("is-invalid");
	} else {
		itemIdDiv.addClass("is-invalid");
	}

	if(itemPrice) {
		itemPriceDiv.removeClass("is-invalid");
	} else {
		itemPriceDiv.addClass("is-invalid");
	}

	if(itemId && itemPrice) {
		itemIdDiv.val("");
		itemPriceDiv.val("");

		addItemToMarket(itemId, itemPrice);
	}
})

$("#market-modal-confirm").click(function() {
	let items = {}

	let marketBodyDiv = $("#market-modal-items-tbody")

	let itemsDivs = marketBodyDiv.children(".item")
	let itemsCount = itemsDivs.length
	
	let markerId = $("#market-data-modal").data("markerId")

	if(itemsCount == 0) {
		let markerData = { items: {} }

		$.post(`https://${resName}/update-marker-data`, JSON.stringify({ markerId: markerId, markerData: markerData }), function (data) {
			$("#market-data-modal").modal("hide");

			if (data.isSuccessful) {
				$(`#marker-row-id-${markerId}`).data("data", JSON.stringify(markerData))
			} else {
				showError(data.message)
			}
		})
		return;
	}

	itemsDivs.each(function(index, element) {
		let itemDiv = $(element)

		let itemName = itemDiv.find(".item-name").text()
		let itemPrice = parseInt(itemDiv.find(".item-price").text())
		let blackMoney = itemDiv.find(".item-blackmoney").prop("checked")

		items[itemName] = {
			price: itemPrice,
			blackMoney: blackMoney
		}

		if(index == itemsCount - 1) {
			let markerData = { items: items }

			$.post(`https://${resName}/update-marker-data`, JSON.stringify({ markerId: markerId, markerData: markerData }), function (data) {
				$("#market-data-modal").modal("hide");

				if (data.isSuccessful) {
					$(`#marker-row-id-${markerId}`).data("data", JSON.stringify(markerData))
				} else {
					showError(data.message)
				}
			})
		}
	});
});

function inputAnimations(animations, cb) {
	let animationsModal = $("#animations-modal");
	let animationsForm = $("#animations-modal-form");

	$("#animations").empty();

	if(animations && animations.length > 0) {
		animations.forEach(animation => {
			addAnimation(animation)
		})
	} else {
		addAnimation();
	}

	animationsForm.unbind();
	animationsForm.submit(function(event) {
		if (!this.checkValidity()) {
			event.stopPropagation();
			event.preventDefault();
			return;
		} else {
			$(animationsForm).removeClass(".was-validated");
		}

		let animations = [];

		$("#animations").find(".animation-container").each(function() {
			let currentAnimDiv = $(this);

			let animType = currentAnimDiv.find(".animation-type").prop("checked");

			// If it's a scenario
			if(animType) {
				animations.push({
					type: "scenario",
					scenarioName: currentAnimDiv.find(".scenario-name").val(),
					scenarioDuration: parseInt(currentAnimDiv.find(".scenario-duration").val())
				})
			} else { // If it's an animation
				animations.push({
					type: "animation",
					animDict: currentAnimDiv.find(".animation-dictionary").val(),
					animName: currentAnimDiv.find(".animation-name").val(),
					animDuration: parseInt(currentAnimDiv.find(".animation-duration").val())
				})
			}
		})

		animationsModal.modal("hide");

		cb(animations)
	})

	animationsModal.modal("show");
}

function addAnimation(animation) {
	if(!animation) {
		animation = {};
	}

	let fullAnimContainer = $(`
		<div class="animation-container mb-5">
			<div class="form-check form-switch">
				<input class="form-check-input animation-type" type="checkbox">
				<label class="form-check-label animation-type-label">Animation</label>
			</div>

			<div class="animation">
				<div class="input-group">
					<span class="input-group-text">Animation dictionary:</span>
					<input type="text" class="form-control animation-dictionary" value="${animation.animDict || ""}" required>
				</div>
				<div class="input-group mt-1">
					<span class="input-group-text">Animation name:</span>
					<input type="text" class="form-control animation-name" value="${animation.animName || ""}" required>
				</div>
				<div class="input-group mt-1">
					<span class="input-group-text">Animation duration (seconds):</span>
					<input type="number" class="form-control animation-duration" min="1" value="${animation.animDuration || ""}" required>
				</div>
			</div>

			<div class="scenario" style="display: none">
				<div class="input-group">
					<span class="input-group-text">Scenario name:</span>
					<input type="text" class="form-control scenario-name" value="${animation.scenarioName || ""}">
				</div>
				<div class="input-group mt-1">
					<span class="input-group-text">Scenario duration (seconds):</span>
					<input type="number" class="form-control scenario-duration" min="1" value="${animation.scenarioDuration || ""}">
				</div>
			</div>

			<button type="button" class="btn btn-warning float-end btn-sm mt-1 remove-anim-btn">Remove</button>
		</div>
	`);

	let scenarioContainer = fullAnimContainer.find(".scenario");
	let animationContainer = fullAnimContainer.find(".animation");
	let switchLabel = fullAnimContainer.find(".animation-type-label");
	let switchInput = fullAnimContainer.find(".animation-type");

	let removeAnimBtn = fullAnimContainer.find(".remove-anim-btn");

	fullAnimContainer.find(".animation-type").change(function() {
		let isChecked = $(this).prop("checked");

		if(isChecked) {
			scenarioContainer.show();
			scenarioContainer.find(".form-control").prop("required", true);

			animationContainer.hide();
			animationContainer.find(".form-control").prop("required", false);

			switchLabel.text("Scenario");
		} else {
			scenarioContainer.hide();
			scenarioContainer.find(".form-control").prop("required", false);

			animationContainer.show();
			animationContainer.find(".form-control").prop("required", true);

			switchLabel.text("Animation");
		}
	})

	removeAnimBtn.click(function() {
		$(this).parent().remove();
	})

	if(animation && animation.type == "scenario") {
		switchInput.prop("checked", true).trigger("change");
	}

	$("#animations").append(fullAnimContainer);
}

$("#add-animation-btn").click(function(){
	addAnimation();
})

$("#harvest-modal-form").submit(function(event){
	if (!this.checkValidity()) {
		event.stopPropagation();
		event.preventDefault();
		return;
	} else {
		$(this).removeClass(".was-validated");
	}

	let harvestableItems = [];

	$("#harvest-modal-items").find(".harvestable-item").each(function(index, element) {
		let harvestableItem = {
			name: $(this).find(".harvest-item-name").val(),
			minQuantity: parseInt( $(this).find(".harvest-item-min-quantity").val() ),
			maxQuantity: parseInt( $(this).find(".harvest-item-max-quantity").val() ),
			time: parseInt( $(this).find(".harvest-item-time").val() ),
			chances: parseInt( $(this).find(".harvest-item-chance").val()),
		};

		harvestableItems.push(harvestableItem);
	})

	if($("#harvest-item-requires-tool").prop("checked")) {
		var itemTool = $("#harvest-item-tool").val();
	}

	if($("#harvest-item-tool-lose-on-use").prop("checked")) {
		var itemToolLoseQuantity = parseInt($("#harvest-item-tool-lose-quantity").val());
	}

	let markerData = {
		harvestableItems: harvestableItems,
		animations: $("#harvest-data-modal").data("animations"),
		itemTool: itemTool,
		itemToolLoseQuantity: itemToolLoseQuantity
	}

	let markerId = $("#harvest-data-modal").data("markerId")

	$.post(`https://${resName}/update-marker-data`, JSON.stringify({ markerId: markerId, markerData: markerData }), function (data) {
		$("#harvest-data-modal").modal("hide");

		if (data.isSuccessful) {
			$(`#marker-row-id-${markerId}`).data("data", JSON.stringify(markerData))
		} else {
			showError(data.message)
		}
	})
});

$("#harvest-add-item-btn").click(function() {
	addItemToHarvestable();
});

$("#harvest-animations-btn").click(function() {
	let harvestDataModal = $("#harvest-data-modal");

	inputAnimations(harvestDataModal.data("animations"), function(animations) {
		harvestDataModal.data("animations", animations)
	});
});

$("#harvest-item-requires-tool").change(function() {
	if($(this).prop("checked")) {
		$("#harvest-item-tool-div").show();
	} else {
		$("#harvest-item-tool-div").hide();
	}
});

$("#harvest-item-tool-lose-on-use").change(function(){
	if($(this).prop("checked")) {
		$("#harvest-item-lose-quantity-div").show();
	} else {
		$("#harvest-item-lose-quantity-div").hide();
	}
});

function addItemToHarvestable(itemName = "", minQuantity = "", maxQuantity = "", secondsToHarvest = "", chances = "") {
	var itemDiv = $(`
		<div class="mb-4 harvestable-item">
			<p class="text-center fs-3 text-bold">Harvestable Item</p>

			<div class="input-group">
				<span class="input-group-text">Name (ID)</span>
				<input type="text" class="form-control harvest-item-name" placeholder="item_name" required value=${itemName}>
			</div>
			<div class="input-group mt-1">
				<span class="input-group-text">Minimum quantity</span>
				<input type="number" class="form-control harvest-item-min-quantity" placeholder="1" required value=${minQuantity}>
			</div>
			<div class="input-group mt-1">
				<span class="input-group-text">Maximum quantity</span>
				<input type="number" class="form-control harvest-item-max-quantity" placeholder="1" required value=${maxQuantity}>
			</div>
			<div class="input-group mt-1">
				<span class="input-group-text">Time to harvest (seconds)</span>
				<input type="number" class="form-control harvest-item-time" placeholder="5" required value=${secondsToHarvest}>
			</div>	
			<div class="input-group mt-1">
				<span class="input-group-text">Probability to find</span>
				<input type="number" class="form-control harvest-item-chance" placeholder="50%" required value=${chances}>
			</div>

			<button type="button" class="btn btn-sm btn-danger float-end mt-1 remove-harvestable-item-btn">Remove</button>
		</div>
	`);

	$(itemDiv).find(".remove-harvestable-item-btn").click(function() {
		$(this).parent().remove();
	})

	$("#harvest-modal-items").append(itemDiv);
}

$("#process-modal-form").submit(function(event) {
	if (!this.checkValidity()) {
		event.stopPropagation();
		event.preventDefault();
		return;
	} else {
		$(this).removeClass(".was-validated");
	}

	let markerId = $("#process-data-modal").data("markerId")

	let markerData = {
		itemToRemoveName: $("#item-to-remove-name").val(),
		itemToRemoveQuantity: parseInt($("#item-to-remove-quantity").val()),
		itemToAddName: $("#item-to-add-name").val(),
		itemToAddQuantity: parseInt($("#item-to-add-quantity").val()),
		timeToProcess: parseInt($("#process-time").val()),
		animations: $("#process-data-modal").data("animations")
	}

	$.post(`https://${resName}/update-marker-data`, JSON.stringify({ markerId: markerId, markerData: markerData }), function (data) {
		$("#process-data-modal").modal("hide");

		if (data.isSuccessful) {
			$(`#marker-row-id-${markerId}`).data("data", JSON.stringify(markerData))
		} else {
			showError(data.message)
		}
	})
});

$("#process-animations-btn").click(function() {
	let processDataModal = $("#process-data-modal");

	inputAnimations(processDataModal.data("animations"), function(animations) {
		processDataModal.data("animations", animations)
	});
})

$("#weapon-upgrader-modal-confirm").click(function(){
	let weaponUpgraderModal = $("#weapon-upgrader-data-modal");
	let weaponsComponentsDiv = $("#weapon-upgrader-components");
	let weaponsTintsDiv = $("#weapon-upgrader-tints");
	
	let componentsPrices = {};
	let tintsPrices = {};

	weaponsComponentsDiv.find(".form-control").each(function(index, element) {
		let componentDiv = $(element)

		let componentName = componentDiv.data("componentname")
		let componentPrice = componentDiv.val()

		if(componentPrice) {
			componentsPrices[componentName] = componentPrice
		}
	})

	weaponsTintsDiv.find(".form-control").each(function(index, element) {
		let tintDiv = $(element)

		let tintId = parseInt(tintDiv.data("tintid"))
		let tintPrice = parseInt(tintDiv.val())

		if(tintPrice) {
			tintsPrices[tintId] = tintPrice
		}
	})

	let markerData = {
		componentsPrices: componentsPrices,
		tintsPrices: tintsPrices
	}

	let markerId = weaponUpgraderModal.data("markerId")

	$.post(`https://${resName}/update-marker-data`, JSON.stringify({ markerId: markerId, markerData: markerData }), function (data) {
		weaponUpgraderModal.modal("hide");

		if (data.isSuccessful) {
			$(`#marker-row-id-${markerId}`).data("data", JSON.stringify(markerData))
		} else {
			showError(data.message)
		}
	})
})

$("#job-shop-all-jobs").change(function() {
	let jobRanks = $(this).data("ranks");
	let jobName = $(this).val();

	let allRanksSelect = $("#job-shop-all-ranks");

	allRanksSelect.find(".job-shop-rank").remove();

	jobRanks[jobName].forEach(rank => {
		let rankDiv = $(`<option class="job-shop-rank" value=${rank.grade}>${rank.label}</option>`);

		allRanksSelect.append(rankDiv);
	})
})

$("#job-shop-modal-confirm").click(function() {
	let jobName = $("#job-shop-all-jobs").val();

	if(!jobName) return;

	let rankGrade = parseInt($("#job-shop-all-ranks").val());
	
	if(jobName && !isNaN(rankGrade)) {
		let jobShopModal = $("#job-shop-data-modal");

		let markerData = {
			allowedJob: jobName,
			minimumRank: rankGrade
		}

		let markerId = jobShopModal.data("markerId")

		$.post(`https://${resName}/update-marker-data`, JSON.stringify({ markerId: markerId, markerData: markerData }), function (data) {
			jobShopModal.modal("hide");

			if (data.isSuccessful) {
				$(`#marker-row-id-${markerId}`).data("data", JSON.stringify(markerData));
			} else {
				showError(data.message);
			}
		})
	}
})

$("#refresh-esx-btn").click(function () {
	$.post(`https://${resName}/refresh-jobs`, JSON.stringify({}), function (data) { });
})

function init() {
	$("#job-creator").show();

	refresh()
}

function exit() {
	$("#job-creator").hide();

	$.post(`https://${resName}/exit`)
}

function startTimedProgressBar(time, text) {
	let progressBarDiv = $("#job-creator-progressbar-div");
	let progressBar = $("#job-creator-progressbar")

    $("#job-creator-progressbar-text").text(text);
    progressBar.css({width: `0%`});
    progressBarDiv.fadeIn();

    let minTime = time/100;

    let progress = 0;

	progressBar.css({"transition-duration": `${minTime}ms`})

    let progressBarInterval = setInterval(() => {
        if(progress >= 100) {
            progressBarDiv.fadeOut();
            clearInterval(progressBarInterval)
        } else {
            progress++;
            progressBar.css({width: `${progress}%`});
        }
    }, minTime);
}

window.addEventListener('message', (event) => {
	let data = event.data;
	let action = data.action;

	if (action == 'show') {
		init();
	} else if(action == "progressBar") {
		startTimedProgressBar(data.time, data.text)
	} else if(action == "notAllowed") {
		$("#not-allowed-ace").text(`
			add_ace group.admin ${data.acePermission} allow # Add permission to group
		`)

		$("#not-allowed-steamid").text(`
			# Can also be identifier.${data.steamId}
		`)

		$("#not-allowed-license").text(`
			add_principal identifier.${data.license} group.admin # Add player to the group
		`)
		$("#not-allowed-container").show();
	}
})

$("#close-main-btn").click(function () {
	exit()
})

$("#close-markers-btn").click(function () {
	$("#job-markers").hide();
	$("#job-creator").show();
})

$("#close-btn-not-allowed-menu").click(function() {
	$("#not-allowed-container").hide();
	exit();
})

$("#close-public-markers-btn").click(function() {
	$("#public-markers").hide();
	$("#job-creator").show();
})

$("#public-markers-btn").click(function() {
	openJobMarkers('public_marker', "Public")
})