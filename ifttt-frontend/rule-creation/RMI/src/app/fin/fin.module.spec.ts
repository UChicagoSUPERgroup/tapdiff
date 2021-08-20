import { FinModule } from './fin.module';

describe('FinModule', () => {
  let finModule: FinModule;

  beforeEach(() => {
    finModule = new FinModule();
  });

  it('should create an instance', () => {
    expect(finModule).toBeTruthy();
  });
});
