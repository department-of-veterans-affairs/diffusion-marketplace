# frozen_string_literal: true

# Importer specs
require 'rails_helper'
require 'rake'
Rails.application.load_tasks

describe 'Importer' do
  before do
    flow3 = Practice.find_by(slug: 'flow3')
    Practice.find_by(slug: 'flow3').destroy if flow3.present?
  end

  after do
    flow3 = Practice.find_by(slug: 'flow3')
    Practice.find_by(slug: 'flow3').destroy if flow3.present?
  end

  context 'when running import_answers task' do
    it 'creates Practices with the correct fields filled out' do
      Rake::Task['db:seed'].execute
      Rake::Task['importer:import_answers'].execute

      expect(Practice.count).to be(1)

      flow3 = Practice.first
      # Basic answers
      expect(flow3.name).to eq('FLOW3')
      expect(flow3.description).to eq('Enabling a 53% faster delivery of prosthetic limbs and automating prosthetic limb procurement processes improves the continuity of care for Veterans.')
      expect(flow3.initiating_facility).to eq('vha_663')
      expect(flow3.date_initiated).to eq(DateTime.strptime('2/22/2019', "%m/%d/%Y"))
      expect(flow3.number_adopted).to be(25)
      expect(flow3.support_network_email).to eq('FLOW3@va.gov')
      expect(flow3.va_pulse_link).to eq('https://www.vapulse.net/groups/flow3')
      expect(flow3.implementation_time_estimate).to eq('6-12 months')
      expect(flow3.summary).to include('FLOW3 is a system of three interrelated software')
      expect(flow3.difficulty_aggregate).to be(1)
      expect(flow3.sustainability_aggregate).to be(2)
      expect(flow3.origin_title).to eq('Innovating delivery processes')
      expect(flow3.origin_story).to include('Dr. Jeffrey Heckman, a physician in the VA Puget S')
      expect(flow3.need_new_license).to be(false)
      expect(flow3.training_test).to be(true)
      expect(flow3.training_length).to eq('126 minutes over 1 month initial training')
      expect(flow3.required_training_summary).to include('At your own pace, one month per group')
      expect(flow3.phase_gate).to include('Initial Diffusion')
      expect(flow3.it_required).to be(true)
      expect(flow3.need_new_license).to eq(false)

      # Practice Partners
      expect(flow3.practice_partners.count).to eq(1)
      expect(flow3.practice_partners.first.name).to eq('Diffusion of Excellence')

      # VA Employees
      expect(flow3.va_employees.count).to eq(4)
      expect(flow3.va_employees.first.name).to eq('Dr. Jeffrey T. Heckman')

      # Categories
      expect(flow3.categories.count).to be(7)
      expect(flow3.categories.find_by(name: 'Prosthetics and Rehabilitation')).to be_truthy

      # Clinical Conditions
      expect(flow3.clinical_conditions.count).to be(4)
      expect(flow3.clinical_conditions.first.name).to eq('prosthetic devices')

      # Job Positions
      expect(flow3.job_positions.count).to be(1)
      expect(flow3.job_positions.first.name).to eq('Clinic based physician')

      # Ancillary Services
      expect(flow3.ancillary_services.count).to be(1)
      expect(flow3.ancillary_services.first.name).to eq('Rehabilitation & Prosthetics')

      # Clinical Locations
      expect(flow3.clinical_locations.count).to be(3)
      expect(flow3.clinical_locations.find_by(name: 'Community Based Outpatient Clinic (CBOC)')).to be_truthy

      # Departments
      expect(flow3.departments.count).to be(4)
      expect(flow3.departments.find_by(name: 'Discharge Planning')).to be_truthy

      # Publications
      expect(flow3.publications.count).to be(0)

      # Risk Mitigation
      expect(flow3.risk_mitigations.count).to be(1)
      expect(flow3.risk_mitigations.first.risks.count).to be(1)
      expect(flow3.risk_mitigations.first.mitigations.count).to be(2)
      expect(flow3.risk_mitigations.first.risks.first.description).to include('If FLOW3 Practice Champions do not allocate suffic')
      expect(flow3.risk_mitigations.first.mitigations.first.description).to include('Support Practice Champions with a pre-implementati')
      expect(flow3.risk_mitigations.first.mitigations.last.description).to include('Empower and support Practice Champions with offici')

      # Additional Staffs
      expect(flow3.additional_staffs.count).to be(5)
      manager = flow3.additional_staffs.find_by(title: 'Implementation manager ')
      expect(manager).to be_truthy
      expect(manager.hours_per_week).to eq('3 hours per week for 1 month total')
      expect(manager.duration_in_weeks).to eq('Permanent')

      # Additional Resources
      expect(flow3.additional_resources.count).to be(1)
      expect(flow3.additional_resources.first.description).to eq('VISN-Wide Corporate Data Warehouse (CDW) Access')

      # Required Staff Training
      expect(flow3.required_staff_trainings.count).to be(1)
      expect(flow3.required_staff_trainings.first.title).to eq('Clinical Staff')

      # Costs
      expect(flow3.costs.count).to be(2)
      expect(flow3.costs.first.description).to eq('Minimal FTE')
      expect(flow3.costs.last.description).to eq('Minimal sustainment cost')

      # Difficulties?
      # expect(flow3.difficulties.count).to be(1)
      # expect(flow3.difficulties.first.description).to be(nil)

      # Domains
      expect(flow3.domains.count).to be(2)
      expect(flow3.domains.first.name).to eq('Veteran')
      expect(flow3.domains.last.name).to eq('Operational')

      # Practice Permissions
      expect(flow3.practice_permissions.count).to be(0)

      # Timelines
      expect(flow3.timelines.count).to be(4)
      expect(flow3.timelines.first.milestone).to eq('Assemble the team and choose a Practice Champion')
      expect(flow3.timelines.first.timeline).to eq('Month 1')
    end
  end
end