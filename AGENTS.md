# PantryMate — Local AGENTS.md

## 1. Project Identity

- **Project:** PantryMate
- **Type:** Cross-platform mobile application
- **Framework:** Flutter
- **Language:** Dart
- **Target platforms:** Android and iOS

PantryMate is a smart household management application designed to help users manage food inventory, expiration dates, and shopping activities.

This file contains project-specific instructions only. General development workflow, agent orchestration, Git/GitHub, code quality, security, dependency approval, and verification rules are inherited from the applicable Global `AGENTS.md`.

## 2. Mandatory Instruction Loading Verification

Before performing any project task, the Main Agent must verify the effective instructions.

1. Identify the actual Codex global instructions file and verify whether it is automatically loaded.
2. Locate and read the project's root `AGENTS.md`.
3. Read any additional applicable `AGENTS.md` files in parent directories or relevant subdirectories.
4. Confirm that both Global and Local instructions are available and applicable to the current task.
5. Identify any conflicting rules and resolve them according to the documented instruction hierarchy.
6. Never assume a file is loaded merely because it exists.

Before starting the initial planning phase, provide an instruction verification report containing:

- Global instructions: exact path and loading status.
- Local instructions: exact path and loading status.
- Other applicable instruction files, if any.
- Conflicts or missing instructions.
- Confirmation that the effective rules have been considered.

If either required instruction set cannot be verified, stop and explain the issue. Do not begin planning or implementation until the problem is resolved.

## 3. Product Scope

The initial product scope includes:

1. **Household management**
    - Create and manage a household.
    - Invite and manage household members.
    - Support shared access to household data.

2. **Food inventory**
    - Add, edit, view, and remove food items.
    - Track quantities and units.
    - Organize items into categories.
    - Track inventory changes.

3. **Expiration tracking**
    - Store expiration dates.
    - Identify expired and soon-to-expire items.
    - Provide relevant expiration reminders.

4. **Low-stock management**
    - Configure minimum stock thresholds.
    - Identify items that need replenishment.
    - Define low-stock behavior.

5. **Shopping lists**
    - Create and manage shopping lists.
    - Add items manually or from low-stock suggestions.
    - Share lists between household members.
    - Track purchased items.

6. **Consumption history**
    - Track consumed or removed items.
    - Keep a history of inventory changes.

7. **Notifications**
    - Expiration reminders.
    - Low-stock alerts.
    - Relevant household activity notifications.

8. **Dashboard**
    - Display inventory summaries.
    - Highlight expired and soon-to-expire items.
    - Show low-stock items.
    - Provide quick access to shopping lists.

These capabilities define the initial scope, not finalized business rules. Unresolved behavior must be documented as a proposal for user approval.

## 4. Flutter-Specific Requirements

The technical specification must evaluate and recommend the following:

### Architecture
- Suitable Flutter application architecture.
- Clear separation of presentation, business logic, and data access.
- Feature-based folder organization where appropriate.
- Reusable widgets and shared components.
- Dependency injection strategy.

### State Management
- Compare suitable Flutter state management solutions.
- Recommend one based on project complexity, maintainability, and testability.
- Explain the reasoning behind the recommendation.

### Navigation
- Define the navigation and routing strategy.
- Handle authentication-dependent routes if authentication is included.
- Handle navigation states and deep links where applicable.

### Platform Compatibility
- Identify Android and iOS requirements.
- Document platform-specific differences.
- Respect platform UI conventions.
- Handle runtime permissions correctly.
- Account for application lifecycle behavior.

### Data and Backend
Evaluate suitable options for:
- Backend/API architecture.
- Database and data modeling.
- Authentication and authorization.
- Local persistence.
- Remote data synchronization.
- Offline-first or online-first behavior.

Do not assume that a specific backend, database, or hosting provider has already been selected.

### Mobile Capabilities
Evaluate the implementation approach for:
- Local and push notifications.
- Background tasks.
- Network connectivity detection.
- Offline operations and synchronization.
- Secure local storage.
- Image capture or selection if required.

### Mobile UI/UX
The application must provide:
- Responsive layouts for different mobile screen sizes.
- Consistent design and reusable UI components.
- Clear loading, empty, success, and error states.
- Accessible controls and readable content.
- Appropriate Android and iOS interaction patterns.
- RTL readiness if Arabic localization is included.

The final design direction and supported languages must be established in the specification.

## 5. Initial Planning Phase

The first project task is documentation and planning only.

Create these three files in the project root:

- `SPEC.md`
- `PLAN.md`
- `TEST.md`

### SPEC.md — Product and Technical Specification

Define:

- Product vision and objectives.
- Target users and use cases.
- Functional and non-functional requirements.
- Feature behavior and business rules.
- User roles and permissions.
- Data entities and relationships.
- Proposed Flutter architecture.
- Proposed backend and database approach.
- Authentication strategy.
- Offline and synchronization strategy.
- Notification strategy.
- Android and iOS compatibility requirements.
- Technical alternatives, advantages, disadvantages, and recommendations.
- Acceptance criteria for functional requirements.

Every unresolved business or technical decision must be clearly identified, with alternatives and a recommendation where appropriate.

### PLAN.md — Project Roadmap

Define:

- Project phases.
- Features broken into manageable tasks.
- Task dependencies and execution order.
- Flutter-specific implementation considerations.
- Mobile platform risks.
- Expected deliverables.
- Acceptance criteria for each task.
- Required verification checkpoints.

Organize implementation around complete, integrated features rather than disconnected frontend and backend work.

### TEST.md — Testing Strategy

Define the testing approach for the proposed Flutter architecture, including applicable:

- Dart unit tests.
- Flutter widget tests.
- Integration tests.
- API and contract tests.
- Database and persistence tests.
- Authentication and authorization tests.
- Offline and synchronization tests.
- Notification tests.
- Android and iOS platform tests.
- End-to-end tests.
- Performance and security checks.

For each testing level, specify important scenarios, expected results, and passing conditions.

The testing strategy must reflect the actual architecture proposed in `SPEC.md`.

## 6. Planning Phase Restrictions

During this initial phase:

- Only inspect the project environment and existing files as necessary.
- Create `SPEC.md`, `PLAN.md`, and `TEST.md`.
- Do not generate application implementation code.
- Do not initialize or modify the Flutter application structure.
- Do not install or modify dependencies.
- Do not create database migrations.
- Do not implement UI, backend, or API functionality.
- Do not start deployment or external infrastructure setup.

After creating the three documents, review their consistency and identify unresolved decisions.

**Stop and wait for explicit user approval before proceeding to design or implementation.**